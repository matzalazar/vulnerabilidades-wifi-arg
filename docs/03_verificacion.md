# 03 - Verificación de handshake

Una vez realizada la captura, es fundamental verificar que el archivo `.cap` contenga un handshake válido. De lo contrario, cualquier intento de descifrado con diccionario fallará.

## Cómo verificar

Usá el siguiente script:

`scripts/verificar_handshakes.sh`

Este script recorre todos los archivos `.cap` en `scripts/output/`, ejecuta `aircrack-ng` con un diccionario vacío (`/dev/null`) y detecta si el handshake fue capturado exitosamente.

## Ejemplo de salida

```
Verificando archivos .cap en scripts/output

Analizando: handshake_MiRed_20250723_124533.cap  
Handshake encontrado  
-------------------------

Analizando: handshake_BVNET-FAAC_20250723_124700.cap  
Sin handshake válido  
-------------------------
```

## Errores comunes

- `Pre-condition Failed: ap_cur != NULL`: el archivo no contiene información válida del punto de acceso.
- `0 handshake`: no se detectó ningún cliente reconectándose o el ataque de deauth falló.

## Limpieza opcional

Para eliminar los `.cap` sin handshake podés usar este comando:

`find scripts/output/ -name "*.cap" -exec aircrack-ng -a2 -w /dev/null {} \; | awk '/^Reading packets/ {archivo = $3} /0 handshake/ {print archivo}' | xargs -r rm`

Este comando:

- Verifica cada `.cap`
- Detecta si contiene "0 handshake"
- Borra automáticamente los archivos inválidos

> 💡 Consejo: Siempre verificar tus capturas antes de lanzar un ataque por diccionario. Archivos sin handshake son inútiles para cracking.
