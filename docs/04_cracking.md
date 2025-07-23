# 04 - Cracking WPA/WPA2 con diccionarios

Luego de capturar un handshake válido, podés intentar descifrar la contraseña usando fuerza bruta con un diccionario predefinido.

## Objetivo

Buscar la contraseña de una red WPA/WPA2 utilizando un diccionario de claves comunes o generadas específicamente.

## Requisitos

- Un archivo `.cap` verificado con handshake válido
- El `BSSID` correspondiente a la red capturada
- Un diccionario `.txt` con claves posibles

## Comando base

`aircrack-ng -a2 -w <diccionario.txt> -b <BSSID> <archivo.cap>`

Parámetros:

- `-a2`: modo WPA2
- `-w`: diccionario de palabras
- `-b`: MAC del AP (BSSID)
- `<archivo.cap>`: archivo de captura

## Ejemplo completo

`aircrack-ng -a2 -w diccionarios/output/diccionario_isp_extendido.txt -b XX:AD:XX:02:XX:EE scripts/output/handshake_ISPWiFiXXXX24GHz_20250723_135300.cap`

## Consejos

- Usá diccionarios específicos.
- Cuanto más realista el diccionario, más chances de éxito.
- Podés generar diccionarios personalizados con scripts como:

`diccionarios/dict_isp.py`  
`diccionarios/dict_isp_extendido.py`

## ⏱Tiempos

El tiempo de ataque depende de:

- Tamaño del diccionario
- Potencia de CPU/GPU
- Complejidad de la clave

Un buen diccionario pequeño puede encontrar contraseñas en segundos.
