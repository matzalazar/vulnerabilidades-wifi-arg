# 02 - Captura de handshake (WPA/WPA2)

Este paso permite capturar el proceso de autenticación entre un cliente y un punto de acceso, con el fin de extraer el handshake y posteriormente intentar descifrar la contraseña mediante fuerza bruta o diccionario.

## Objetivo

Forzar la reconexión de dispositivos a una red WiFi con seguridad WPA/WPA2 para capturar el handshake en el aire.

## Requisitos

- Interfaz WiFi con soporte para modo monitor e inyección
- Herramientas instaladas: `aircrack-ng`, `airodump-ng`, `aireplay-ng`, `timeout`, etc.
- Una red objetivo con al menos un cliente conectado

## Ejecución

`scripts/captura_individual.sh <INTERFAZ> <BSSID> <CANAL> <ESSID> [DURACIÓN]`

Parámetros:

- `INTERFAZ`: interfaz WiFi a usar (ej. `wlan0`)
- `BSSID`: dirección MAC del punto de acceso
- `CANAL`: canal en el que opera la red
- `ESSID`: nombre de la red WiFi (sin espacios)
- `DURACIÓN`: tiempo en segundos (opcional, por defecto 90)

Ejemplo:

`scripts/captura_individual.sh wlan0 A4:7C:C9:83:75:F8 2 BVNET-75EF 60`

## ¿Qué hace el script?

1. Mata procesos conflictivos (`wpa_supplicant`, etc.)
2. Activa modo monitor
3. Busca clientes conectados a la red
4. Si detecta clientes, comienza la captura con `airodump-ng`
5. En paralelo, lanza 50 paquetes de deauth con `aireplay-ng`
6. Guarda todos los archivos en `scripts/output/`
7. Restaura automáticamente la red al finalizar

## Archivos generados

- `handshake_<ESSID>_<timestamp>.cap`: archivo de captura
- Archivos auxiliares `.csv`, `.kismet.csv`, etc.

## Consideraciones

- Si no hay clientes conectados, no se podrá capturar el handshake.
- El archivo `.cap` debe validarse posteriormente con `aircrack-ng` u otra herramienta.
- El script usa `sleep 5` antes de lanzar el ataque de deauth para dar tiempo a `airodump-ng` a iniciar.

## Restauración de red

Todo el proceso es reversible. El script:

- Desactiva el modo monitor
- Reactiva `NetworkManager` y `wpa_supplicant`

Si algo falla, podés restaurar manualmente:

```bash
sudo airmon-ng stop <interfaz_monitor>
sudo service NetworkManager restart
sudo service wpa_supplicant restart
```