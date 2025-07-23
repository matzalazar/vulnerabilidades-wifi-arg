# Contramedidas y Buenas Prácticas para Redes WiFi Domésticas

Este documento reúne recomendaciones para **mejorar la seguridad de redes WiFi** domésticas o de PyMEs, especialmente frente a ataques documentados en este repositorio.

## 1. Cambiar la contraseña por defecto del router

- Nunca uses la clave que viene impresa por defecto.
- Evitá usar información personal (nombre, DNI, dirección).
- Usá contraseñas largas, con letras mayúsculas, minúsculas, números y símbolos.

## 2. Desactivar WPS (WiFi Protected Setup)

- Muchos routers aún permiten ataques por PIN.
- Desactivarlo desde la configuración del router.

## 3. Cambiar el nombre de la red (SSID)

- No uses nombres que revelen tu proveedor (como “Fibertel WiFi…”).
- Usar un nombre genérico evita que te cataloguen automáticamente como vulnerable.

## 4. Mantener actualizado el firmware del router

- Revisá cada tanto si hay actualizaciones de seguridad en el panel de configuración.
- Muchos exploits afectan versiones viejas de firmware.

## 5. Auditar tu propia red periódicamente

- Usá herramientas como `airodump-ng`, `nmap` o `arp-scan` para detectar dispositivos conectados.
- Revisa si hay handshakes disponibles o dispositivos sospechosos conectados.

## 6. Habilitar WPA3 si está disponible

- Si tu router y dispositivos lo soportan, WPA3 ofrece mayor protección contra ataques por diccionario y otros vectores conocidos.

## 7. Cambiar credenciales de administración del router

- No dejes “admin/admin” o “admin/1234”.
- Cambiá el usuario y contraseña del panel web de configuración.

## 8. Deshabilitar el acceso remoto innecesario

- Algunos routers permiten acceso vía web o SSH desde internet.
- Esto debería estar deshabilitado si no lo necesitás expresamente.

## 9. Registrar eventos de seguridad

- Muchos routers modernos ofrecen logs: revisalos.
- Si ves múltiples intentos de conexión o reinicios sospechosos, investigalo.

## 10. Simulá ataques controlados

- Probá ataques de deauth contra tu propia red y verificá si podés capturar handshakes.
- Evaluá si tu clave resiste ataques por diccionario.
