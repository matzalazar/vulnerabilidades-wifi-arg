# Ejemplo de Descifrado con Diccionario Personalizado

Este documento presenta **ejemplos reales de ataques exitosos por diccionario** sobre handshakes WPA2 capturados en redes de prueba propias. El objetivo es demostrar empíricamente el tiempo necesario para descifrar contraseñas predecibles, y evidenciar la gravedad de las configuraciones inseguras aún utilizadas por algunos proveedores de servicios de Internet.

> ⚠️ **Advertencia:** Esta información se brinda exclusivamente con fines educativos y/o de auditoría ética, y no debe utilizarse para atacar redes sin consentimiento expreso.

## Caso 1 — Crackeo completo en 7 minutos

```bash
                               Aircrack-ng 1.X 

      [00:0X:12] 19116544/90000000 keys tested (44991.8X k/s) 

      Time left: 26 minutes, 15 seconds                         21.24%

                          KEY FOUND! [ XXXXXXXX157 ]


      Master Key     : E4 XX 28 CA D9 XA XX X4 X9 EC 51 DA 22 91 XX CF 
                       46 B1 XX 06 DA C2 8X 56 8BXX 4C XX 51 CX 8X BB XX 

      Transient Key  : BB 0D 2C 24 65 82 50 B6 DD BA FD 86 E2 XF 1B X0 
                       B8 D0 81 C0 F0 XX B9 E8 FX 8B 9A 81 XA 1X F1 D2 
                       1D XB A6 89 X4 C0 6E EE XX 48 C6 9B CF X9 A9 CX 
                       XX 0C F8 18 0C 94 FD 99 AC 2X 4X 6E E4 6D CD EX 

      EAPOL HMAC     : 65 XX 68 CX C5 4C X1 FB 85 11 D2 1X XC 5D D1 40 
```

**Datos clave:**

- Tiempo total: ~X minutos
- Diccionario: 90 millones de claves
- Contraseña encontrada: XXXXXXXX157
- Estructura típica: prefijo + número de DNI
- Resultado obtenido con un equipo estándar (Ryzen 7 sin GPU)


## Caso 1 — Crackeo completo en 50 segundos

```bash
                               Aircrack-ng 1.X 

      [00:00:50] 225X944/9000000 keys tested (45140.55 k/s) 

      Time left: 2 minutes, 29 seconds                          25.04%

                          KEY FOUND! [ XXXXXXX567 ]


      Master Key     : DC A4 6E 26 E0 62 1D 44 BD 60 52 A4 X8 6X 2D D4 
                       E8 EX XX DC 6C 4X 42 9F F0 41 2D 8X 1X 0C 90 DB 

      Transient Key  : A8 XE 9D XX 0X 5F DX 00 00 00 00 00 00 00 00 00 
                       00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
                       00 XX 00 00 00 00 XX 00 00 00 00 00 00 00 00 00 
                       00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 

      EAPOL HMAC     : 9F 22 85 64 DX XA 9A XX X1 AD 9A 64 5B A1 XX X0 
```

**Datos clave:**

- Tiempo total: ~50 segundos
- Diccionario: 90 millones de claves
- Contraseña encontrada: XXXXXXX567
- Estructura típica: prefijo + número de DNI - último dígito
- Resultado obtenido con un equipo estándar (Ryzen 7 sin GPU)

## Análisis

Estos resultados muestran que:

- El uso de contraseñas predecibles (como claves basadas en números de documento) expone la red a ser comprometida en minutos.
- Un atacante con hardware modesto puede ejecutar ataques de diccionario exitosos en menos de 10 minutos.
- Las contraseñas por defecto ofrecidas por algunos ISP representan una vulnerabilidad crítica estructural.

> 📝 Estos ejemplos provienen de pruebas realizadas sobre infraestructura controlada por el autor. Cualquier uso indebido de esta información es exclusiva responsabilidad del usuario.