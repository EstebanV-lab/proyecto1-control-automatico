# Proyecto corto #3 — Diseño de compensadores por Root Locus

Este programa permite estudiar una planta de control a partir de sus polos y ceros, diseñar un compensador **P, PI, PD o PID**, observar cómo cambia el **lugar de las raíces** y comparar la respuesta al escalón del sistema original con la del sistema compensado.

---

## 1. Requisitos

Para ejecutar el programa se necesita:

- MATLAB.
- **Control System Toolbox**.
- El archivo:


No se necesita ingresar puntos con el mouse. Todos los datos se escriben desde la **Command Window** de MATLAB.

---

## 2. Abrir el proyecto

1. Guarde `proyecto3_root_locus_consola_v2.m` en una carpeta fácil de encontrar.
2. Abra MATLAB.
3. En el panel **Current Folder**, navegue hasta la carpeta donde guardó el archivo.
4. Abra el archivo haciendo doble clic sobre él.

También puede verificar que MATLAB se encuentre en la carpeta correcta escribiendo:

```matlab
pwd
```

---

## 3. Ejecutar el programa

Hay dos formas sencillas.

### Opción A — Botón Run

Con el archivo abierto en el editor de MATLAB, presione el botón:

```text
Run
```

### Opción B — Command Window

Escriba:

```matlab
proyecto3_root_locus_consola_v2
```

y presione **Enter**.

---

## 4. Ingresar los ceros de la planta

El programa mostrará:

```text
Ingrese los CEROS de G(s):
```

Si la planta no tiene ceros, puede escribir:

```text
[]
```

o simplemente presionar **Enter**.

Si, por ejemplo, existe un cero en `s = -2`, escriba:

```text
[-2]
```

---

## 5. Ingresar los polos de la planta

El programa mostrará:

```text
Ingrese los POLOS de G(s):
```

Por ejemplo, para la planta:

```text
G(s) = 1 / ((s+1)(s+4))
```

se deben escribir:

```text
[-1 -4]
```

Si hay polos complejos, deben escribirse en pares conjugados. Ejemplo:

```text
[-2+3i -2-3i]
```

---

## 6. Primer Root Locus

Después de ingresar polos y ceros, MATLAB:

1. Construye la función de transferencia `G(s)`.
2. Muestra su ecuación característica.
3. Abre la **Figura 1**, correspondiente al:

```text
Root Locus de la planta original G(s)
```

Esta gráfica sirve como referencia para observar la distribución original de polos y las trayectorias del lugar de las raíces.

---

## 7. Seleccionar el compensador

En la Command Window aparecerá:

```text
1) P
2) PI
3) PD
4) PID
```

Escriba el número correspondiente y presione **Enter**.

### P

```text
1
```

### PI

```text
2
```

### PD

```text
3
```

### PID

```text
4
```

---

## 8. Ingresar el polo deseado

Después se solicita:

```text
Polo deseado s_d =
```

El valor se escribe directamente en consola.

Ejemplos:

```text
-2
```

o:

```text
-3+2i
```

Para un polo complejo solo es necesario introducir uno de los dos polos conjugados. El programa considera automáticamente la existencia de su conjugado.

---

## 9. Segundo Root Locus

Una vez calculado el compensador, MATLAB muestra:

- `C(s)`.
- La nueva ecuación característica.
- Los polos obtenidos.
- El error entre el polo solicitado y el polo resultante.

Después abre la **Figura 2**:

```text
Root Locus compensado C(s)G(s)
```

En esta gráfica se puede observar el nuevo lugar de las raíces después de agregar el compensador.

El programa también marca:

- El polo deseado.
- Los polos obtenidos en el sistema compensado.

La Command Window mostrará:

```text
Revise la grafica y presione ENTER para mostrar la respuesta al escalon...
```

Revise el segundo Root Locus y luego presione **Enter**.

---

## 10. Respuesta al escalón

Después de presionar Enter se abre la **Figura 3**:

```text
Comparacion de la respuesta al escalon
```

La gráfica contiene:

- **Sistema original**.
- **Sistema compensado**.

Esta comparación permite analizar cambios en:

- Rapidez de respuesta.
- Tiempo de establecimiento.
- Sobreimpulso.
- Oscilaciones.
- Error de estado estacionario.

---

## 11. Casos de prueba recomendados

Utilice inicialmente:

```text
CEROS: []
POLOS: [-1 -4]
```

### Caso P

Seleccione:

```text
Opcion: 1
Polo deseado: -2.5+0.8660254i
```

Resultado aproximado esperado:

```text
Kp = 3
```

---

### Caso PI

Seleccione:

```text
Opcion: 2
Polo deseado: -1+2i
```

Resultado aproximado esperado:

```text
Kp = 7
Ki = 15
```

---

### Caso PD

Seleccione:

```text
Opcion: 3
Polo deseado: -3+2i
```

Resultado aproximado esperado:

```text
Kp = 9
Kd = 1
```

---

### Caso PID

Seleccione:

```text
Opcion: 4
Polo deseado: -3+2i
```

Cuando el programa solicite:

```text
Ingrese el valor de Ki que desea fijar:
```

escriba:

```text
13
```

Resultado aproximado esperado:

```text
Kp = 15
Ki = 13
Kd = 2
```

---

## 12. Probar otro compensador

Después de mostrar las gráficas, el programa preguntará:

```text
¿Desea probar otro compensador con la misma planta? (s/n):
```

Escriba:

```text
s
```

para realizar otro diseño sin volver a ingresar la planta.

Escriba:

```text
n
```

para finalizar.

---

## 13. Significado de las tres figuras

### Figura 1 — Root Locus original

Muestra el comportamiento de la planta antes de agregar el compensador.

### Figura 2 — Root Locus compensado

Muestra cómo el compensador modifica el lugar de las raíces y permite comparar la ubicación deseada con los polos realmente obtenidos.

### Figura 3 — Respuesta al escalón

Compara directamente la respuesta temporal del sistema original y del sistema compensado.

---

## 14. Errores comunes

### MATLAB no reconoce `tf`, `rlocus`, `feedback` o `step`

Verifique que tenga instalado **Control System Toolbox**.

Puede comprobarlo con:

```matlab
ver
```

### Error al ingresar polos complejos

Debe usar `i`:

```text
-3+2i
```

No escriba:

```text
-3+2
```

### PI, PD o PID con un polo completamente real

Para estos casos se recomienda utilizar un polo con parte imaginaria distinta de cero, por ejemplo:

```text
-3+2i
```

### El resultado no coincide exactamente con el polo solicitado

Esto puede ocurrir especialmente con un compensador P si la ubicación ingresada no pertenece al lugar de las raíces disponible para una ganancia proporcional positiva.

---

## 15. Resumen de uso

```text
1. Ejecutar el programa.
2. Ingresar ceros.
3. Ingresar polos.
4. Revisar el Root Locus original.
5. Seleccionar P, PI, PD o PID.
6. Escribir el polo deseado.
7. Revisar el Root Locus compensado.
8. Presionar Enter.
9. Revisar la respuesta al escalón.
10. Elegir si se desea realizar otra prueba.
```
