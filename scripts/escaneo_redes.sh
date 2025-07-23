#!/bin/bash

# ========== VALIDACIÓN DE DEPENDENCIAS ==========
REQUIRED_CMDS=(airmon-ng airodump-ng timeout iw awk grep)

for cmd in "${REQUIRED_CMDS[@]}"; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "❌ Faltante: $cmd. Instalalo para continuar."
    exit 1
  fi
done

# ========== DETECCIÓN Y PARÁMETROS ==========
IFACE_ORIGINAL="${1:-}"
SCAN_DURATION="${2:-60}"

if [[ -z "$IFACE_ORIGINAL" ]]; then
  IFACE_ORIGINAL=$(iw dev | awk '$1=="Interface"{print $2}' | head -n 1)
  if [[ -z "$IFACE_ORIGINAL" ]]; then
    echo "No se encontró interfaz Wi-Fi. Pasala como argumento: ./escaneo_redes.sh wlan0 [duración]"
    exit 1
  fi
  echo "Interfaz detectada automáticamente: $IFACE_ORIGINAL"
fi

IFACE_MONITOR="$IFACE_ORIGINAL"

# ========== CONFIGURACIÓN ==========
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_DIR="$SCRIPT_DIR/output"
mkdir -p "$OUTPUT_DIR"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
OUTPUT_BASE="$OUTPUT_DIR/redes_scan_$TIMESTAMP"
OUTPUT_TXT="$OUTPUT_DIR/redes_detectadas_$TIMESTAMP.txt"
CSV_FILE="${OUTPUT_BASE}-01.csv"

# ========== ESCANEO ==========
echo "Matando procesos que interfieren..."
sudo airmon-ng check kill

echo "Activando modo monitor en $IFACE_ORIGINAL..."
sudo airmon-ng start "$IFACE_ORIGINAL"

# Verifica si el nombre cambió (ej: wlan0 → wlan0mon)
IFACE_RESULT=$(iw dev | awk '/Interface/ {print $2}' | grep "$IFACE_ORIGINAL")
if [[ -z "$IFACE_RESULT" ]]; then
  IFACE_MONITOR=$(iw dev | awk '/Interface/ {print $2}' | grep -v "$IFACE_ORIGINAL")
fi
echo "Usando interfaz en modo monitor: $IFACE_MONITOR"

echo "Escaneando redes durante $SCAN_DURATION segundos..."
sudo timeout "$SCAN_DURATION" airodump-ng --output-format csv -w "$OUTPUT_BASE" "$IFACE_MONITOR"

# ========== PROCESAMIENTO ==========
if [[ -f "$CSV_FILE" ]]; then
  echo "Procesando $CSV_FILE..."
  grep -vE 'Station|^$' "$CSV_FILE" | awk -F',' '{
      gsub(/^ +| +$/, "", $1);
      gsub(/^ +| +$/, "", $14);
      if ($1 != "" && $14 != "") print $1 "," $14
  }' > "$OUTPUT_TXT"
  echo "Listado generado: $OUTPUT_TXT"
else
  echo "No se encontró el archivo CSV de salida."
fi

# ========== RESTAURACIÓN ==========
echo "Desactivando modo monitor..."
sudo airmon-ng stop "$IFACE_MONITOR"

echo "Restaurando servicios de red..."
sudo service NetworkManager restart
sudo service wpa_supplicant restart

echo "Listo. Red Wi-Fi restaurada y resultados disponibles en scripts/output/"
