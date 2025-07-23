#!/bin/bash

# ========== VALIDACIÓN DE DEPENDENCIAS ==========
if ! command -v aircrack-ng &>/dev/null; then
  echo "Falta 'aircrack-ng'. Instalalo para continuar."
  exit 1
fi

# ========== CONFIGURACIÓN ==========
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CAP_DIR="$SCRIPT_DIR/output"

if [[ ! -d "$CAP_DIR" ]]; then
  echo "No existe el directorio $CAP_DIR"
  exit 1
fi

echo "🔍 Verificando archivos .cap en $CAP_DIR"
echo

FOUND_CAPS=0

for cap in "$CAP_DIR"/*.cap; do
  [[ -e "$cap" ]] || continue  # si no hay archivos, skip

  FOUND_CAPS=1
  echo "Analizando: $(basename "$cap")"
  aircrack-ng -a2 -w /dev/null "$cap" | grep -q "1 handshake"

  if [[ $? -eq 0 ]]; then
    echo "Handshake encontrado"
  else
    echo "Sin handshake válido"
  fi

  echo "-------------------------"
done

if [[ "$FOUND_CAPS" -eq 0 ]]; then
  echo "No se encontraron archivos .cap en $CAP_DIR"
fi
