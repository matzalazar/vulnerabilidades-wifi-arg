# Diccionarios Personalizados

Este módulo contiene generadores de claves diseñados específicamente para routers entregados por proveedores en Argentina.

## Estructura

- `dict_isp.py`: genera claves de tipo 004XXXXXXX, 014XXXXXXX, 044XXXXXXX (7 dígitos decimales).
- `dict_isp_extendido.py`: amplía el rango generado, permitiendo un espacio de búsqueda más amplio.

Los diccionarios generados se guardan automáticamente en `diccionarios/output/`.

## Ejemplo de uso

```
python diccionarios/dict_isp.py
python diccionarios/dict_isp_extendido.py
```

Esto produce archivos `.txt` que pueden ser utilizados luego con herramientas como `aircrack-ng`:

`aircrack-ng -w diccionarios/output/dict_isp.txt -b <BSSID> <handshake.cap>`


Por supuesto, con `aircrack-ng` podemos emplear otros diccionarios reconocidos (como `rockyou.txt`).