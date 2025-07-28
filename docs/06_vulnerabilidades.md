# Vulnerabilidades en Routers

Esta herramienta permite **romper las contraseñas por defecto** de routers entregados en Argentina por los dos principales ISP.

## Vector de vulnerabilidad

El ISP más importante del país suele configurar los routers con claves predecibles basadas en una **estructura fija**:

- Prefijo fijo: `004`, `014` o `044`
- Sufijo: número de DNI del titular (en ocasiones sin el último dígito)

Esta práctica introduce una grave debilidad de tipo **predictibilidad en la contraseña**.

## Tamaño del diccionario

Asumiendo un rango de DNIs entre **15.000.000** y **45.000.000**, y tres prefijos posibles, el espacio total es:

    (45.000.000 - 15.000.000) * 3 = 90.000.000 claves

Es decir, el diccionario contiene **90 millones** de claves posibles.

## Tiempo estimado de crackeo

En una PC estándar (i5/i7) con `aircrack-ng`, la velocidad de pruebas es de aproximadamente **45.000 claves/segundo**, por lo tanto:

    90.000.000 / 45.000 ≈ 2000 segundos ≈ 33 minutos

En una GPU o entorno optimizado, el tiempo puede ser aún menor.

## Alternativa vía OSINT

Incluso si la contraseña no es directamente crackeable, la configuración es vulnerable a **ingeniería social**:

- En edificios, muchas veces las **facturas de los clientes** quedan visibles en pasillos o halls de entrada.
- Estas contienen **nombre completo del titular** y el nombre del ISP.
- Con esa información, una simple búsqueda en Google puede derivar en su **CUIL**, y de allí, el **DNI**.
- Basta ese número para probar combinaciones posibles y recuperar la contraseña del router.

## Conclusión

El uso de contraseñas predictibles constituye una **falla de seguridad estructural**. Las operadoras deberían abandonar este esquema de generación y obligar a la configuración personalizada desde el primer uso.
