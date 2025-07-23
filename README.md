# Vulnerabilidades en Redes WiFi Domésticas - Análisis, Herramientas y Pruebas de Concepto

Este repositorio documenta **vulnerabilidades comunes en redes WiFi**, con foco en ataques sobre seguridad inalámbrica (WEP, WPA/WPA2, WPS) y el análisis de configuraciones inseguras en entornos reales. Incluye scripts, capturas de paquetes, diccionarios personalizados y documentación técnica para reproducir ataques **con fines educativos o auditorías autorizadas**.

## ⚠️ Aviso de Responsabilidad

> **Este proyecto es exclusivamente para uso educativo, académico o de auditoría con consentimiento explícito.**
>  
> Queda terminantemente prohibido utilizar este contenido para realizar accesos no autorizados a redes ajenas. El uso indebido puede constituir un delito penal.
> 
> Para más información legal y condiciones de uso, ver [`DISCLAIMER.md`](DISCLAIMER.md).

## Uso Ético Exclusivo

Este proyecto se desarrolla con fines exclusivamente educativos, de concientización y/o auditoría autorizada. Se aplican estrictamente los siguientes principios:

1. **Consentimiento y titularidad:**  
   Toda red WiFi o sistema analizado debe ser de titularidad propia o contar con consentimiento explícito, documentado y por escrito del propietario o responsable legal.  
   **Queda expresamente prohibido** el uso de estas herramientas sobre redes de terceros sin dicha autorización.

2. **Anonimización y resguardo de datos:**  
   Cualquier dato sensible (nombres de SSID, BSSID, direcciones MAC, IPs, hashes, etc.) debe ser debidamente anonimizados antes de su publicación o análisis.  
   Se documenta y justifica el proceso de anonimización de datos en los informes o scripts asociados.

3. **Cumplimiento legal (Argentina):**  
   Este trabajo se rige bajo los principios establecidos en la [Ley 26.388](http://servicios.infoleg.gob.ar/infolegInternet/anexos/135000-139999/136239/norma.htm), que modifica el Código Penal Argentino para tipificar delitos informáticos.  
   En particular, se observa lo establecido en el **Artículo 153**, que penaliza la captación, desvío o interceptación sin autorización de comunicaciones electrónicas.

> 📝 *Todo uso que no cumpla con estas condiciones se considera expresamente una violación del propósito del proyecto y puede constituir un delito penal.*

## Contenido

- [`/docs/`](docs/) — Fundamentos técnicos, tipos de ataques y contramedidas.
- [/diccionarios/](diccionarios/) — Python Scripts para generar diccionarios personalizados.
- [`/scripts/`](scripts/) — Scripts Bash y Python para escaneo, captura, cracking y automatización.
- [`/casos_reales/`](casos_reales/) — Análisis de redes domésticas y PyME con configuraciones débiles.

## Herramientas utilizadas

- `aircrack-ng`, `airodump-ng`, `aireplay-ng`
- Python (verificación de handshakes, generación de diccionarios)
- Bash (automatización de escaneo y ataques)

## Capturas de ejemplo

> Las capturas de tráfico y handshakes contenidas en este repositorio están **anonimizadas y provienen de entornos de prueba controlados**, o fueron recolectadas en redes propias bajo control.

## Dinámica del ataque

- Escaneo de redes wifi cercanas.
- Ataque de desautenticación para forzar reconexión y capturar handshake.
- Captura de handshake WPA2 + ataque por fuerza bruta utilizando diccionarios personalizados.

### Escaneo de redes Wi-Fi

Iniciá el análisis con el escaneo de redes cercanas mediante:

`scripts/escaneo_redes.sh [INTERFAZ] [DURACIÓN]`

- `INTERFAZ`: nombre de la interfaz WiFi (opcional). Si se omite, se detecta automáticamente.
- `DURACIÓN`: duración del escaneo en segundos (opcional, por defecto 60).

Se generan dos archivos dentro de `scripts/output/`:

- `redes_scan_YYYYMMDD_HHMMSS-01.csv`: salida de `airodump-ng`
- `redes_detectadas_YYYYMMDD_HHMMSS.txt`: lista simplificada (BSSID, SSID)

> 💡 Requiere permisos `sudo`. Asegurate de tener un adaptador compatible con modo monitor.

Documentación completa en `docs/01_escaneo.md`.

### Captura de handshake (WPA/WPA2)

Una vez identificada una red, podés iniciar la captura del handshake ejecutando:

`scripts/captura_individual.sh <INTERFAZ> <BSSID> <CANAL> <ESSID> [DURACIÓN]`

- `INTERFAZ`: nombre de la interfaz WiFi (ej. `wlan0`)
- `BSSID`: MAC de la red objetivo
- `CANAL`: canal asignado (ej. `6`)
- `ESSID`: nombre de la red (ej. `MiRedWiFi`)
- `DURACIÓN`: tiempo de captura en segundos (opcional, por defecto 90)

Los archivos generados (formato `.cap`, `.csv`, etc.) se almacenan en `scripts/output/`.

> 💡 El script busca clientes conectados antes de lanzar el ataque de deauth. Si no hay clientes activos, la captura se aborta automáticamente.

Documentación detallada en `docs/02_captura.md`.

### Verificación de handshake

Para comprobar si una captura contiene un handshake válido:

`scripts/verificar_handshakes.sh`

Este script analiza todos los archivos `.cap` dentro de `scripts/output/` usando `aircrack-ng`.

Se imprimirá un resultado por cada archivo:

- `Handshake encontrado`
- `Sin handshake válido`

> ℹ️ Esto **no descifra la contraseña**, solo verifica si hay un handshake presente.

### Ataque por diccionario (cracking WPA/WPA2)

Una vez verificado un archivo `.cap` con handshake válido, podés intentar descifrar la contraseña utilizando un diccionario personalizado:

`aircrack-ng -a2 -w <diccionario.txt> -b <BSSID> <archivo.cap>`

- `-a2`: fuerza modo WPA2
- `-w`: ruta al diccionario (uno propio o generado)
- `-b`: BSSID de la red objetivo
- `<archivo.cap>`: archivo de captura con handshake

Ejemplo:

`aircrack-ng -a2 -w diccionarios/output/diccionario_isp.txt -b XX:AD:XX:02:XX:EE scripts/output/handshake_ISPWiFiXXXX24GHz_20250723_135300.cap`

> 💡 Si la contraseña está en el diccionario, se mostrará en texto claro.

### Diccionarios Personalizados

Se incluyen scripts en `diccionarios/` que generan claves comunes utilizadas por ISPs locales para facilitar ataques de diccionario. Los archivos generados se guardan en `diccionarios/output/` y están optimizados para reducir tiempo de cracking sin sacrificar cobertura.

→ Ver detalles técnicos en `docs/05_diccionarios.md`.

## Contramedidas

Dentro de la documentación [/docs](docs/07_contramedidas.md) se enumeran una serie de contramedidas tendientes a contrarrestar las vulnerabilidades mencionadas.

## Requisitos del sistema

- Linux (idealmente Kali, Parrot o Ubuntu)
- Adaptador WiFi con soporte para modo monitor e inyección de paquetes
- Python 3.7+
- Herramientas de pentesting: `aircrack-ng`, `aireplay-ng`, etc.

## Contribuciones

Las contribuciones están abiertas a investigadores, estudiantes y auditores con interés legítimo en seguridad WiFi. Por favor, asegurate de seguir los lineamientos éticos.

## Licencia

Este repositorio se publica bajo licencia MIT. Ver [`LICENSE`](LICENSE) para más información.
