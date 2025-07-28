# 01 - Escaneo de redes Wi-Fi

Este paso permite identificar redes inalámbricas disponibles antes de intentar cualquier tipo de ataque.

## Objetivo

Realizar un escaneo pasivo de redes Wi-Fi cercanas utilizando `airodump-ng`, y generar un listado limpio de BSSID y SSID para análisis posterior.

## Requisitos

- Adaptador WiFi compatible con **modo monitor**
- Herramientas instaladas: `airmon-ng`, `airodump-ng`, `timeout`, `iw`, `awk`, `grep`
- Linux con privilegios `sudo`

## Ejecución del script

Ejecutá el script de escaneo desde la raíz del proyecto:

`scripts/escaneo_redes.sh [INTERFAZ] [DURACIÓN]`

- `INTERFAZ`: (opcional) nombre de la interfaz Wi-Fi, como `wlan0`, `wlx...`.
- `DURACIÓN`: (opcional) duración del escaneo en segundos. Por defecto: `60`.

Ejemplos:

- Escaneo automático durante 60s:

  `scripts/escaneo_redes.sh`

- Escaneo con interfaz específica y duración personalizada:

  `scripts/escaneo_redes.sh wlan0 30`

## Archivos generados

Los resultados se guardan en `scripts/output/`:

- `redes_scan_20250723_113000-01.csv`: archivo generado por `airodump-ng` (formato CSV estándar).
- `redes_detectadas_20250723_113000.txt`: listado limpio con `BSSID,SSID` uno por línea.

## Restauración de red

El script automáticamente:
- Mata procesos conflictivos (`wpa_supplicant`, `NetworkManager`)
- Activa y desactiva modo monitor
- Restaura servicios al finalizar

Si algo falla, podés restaurar manualmente con:

```bash
sudo airmon-ng stop <interfaz_monitor>
sudo service NetworkManager restart
sudo service wpa_supplicant restart
```

## Errores comunes

- El adaptador no soporta modo monitor/inyección.
- airmon-ng no cambia el nombre de la interfaz.
- El CSV no se genera: puede que no se hayan detectado redes activas.

Verificá que airodump-ng funcione manualmente con:

`sudo airodump-ng wlan0`

Y observá si aparecen redes reales.