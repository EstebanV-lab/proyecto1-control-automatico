# Proyecto individual 2 - Routh-Hurwitz y Root Locus

**EL-5409 Laboratorio de Control Automático**<br>
**Estudiante: Esteban Vargas Fernández.**<br>
**Carné: 2023395790.**

## Descripción

Script que, a partir de los ceros y polos de una función de transferencia G(s) en lazo abierto:

1. Construye G(s) y la ecuación característica de lazo cerrado `1 + K·G(s) = 0`.
2. Arma la tabla de Routh (método en cascada) y determina si el sistema es estable.
3. Grafica el lugar de las raíces (root locus), con los polos y ceros de lazo abierto marcados.

## Requisitos

- MATLAB con Control System Toolbox, o
- GNU Octave con `pkg install -forge control` + `pkg load control`

## Pasos para ejecutar

1. Abrí MATLAB u Octave y ubicá la carpeta actual donde está el archivo `.m`.
2. Ejecutá el script (`F5` en MATLAB, o escribiendo su nombre en Octave).
3. Ingresá los **ceros** de G(s) entre corchetes, separados por espacio (ej: `[-2]`, o `[]` si no tiene ninguno).
4. Ingresá los **polos** de G(s) entre corchetes, separados por espacio (ej: `[-1 -2]`). Debe haber al menos uno.
5. Ingresá el valor de **K** (ganancia de lazo cerrado a evaluar), un solo número positivo, sin corchetes.
6. Leé en consola: G(s), la ecuación característica, la tabla de Routh, y la conclusión de estabilidad.
7. Revisá la ventana del gráfico: el root locus con los polos ("x") y ceros ("o") de lazo abierto, más un cuadrado amarillo marcando dónde caen los polos de lazo cerrado para el K ingresado.

## Formato de entrada

- Siempre entre corchetes `[ ]`, aunque sea un solo valor.
- Números complejos se escriben pegados: `-3+4i` (no `-3 + 4i`).
- Todo complejo debe ingresarse **junto con su conjugado** (ej: `[-3+4i -3-4i]`); si falta, el script lo rechaza y vuelve a preguntar.
- K va sin corchetes, solo el número.

## Ejemplo rápido

```
Ceros: []
Polos: [-1 -3+4i -3-4i]
K: 5
```

Resultado esperado: sistema **estable**, con la tabla de Routh mostrando la primera columna sin cambios de signo.

## Nota

Si un pivote de la tabla de Routh da exactamente cero, el script lo sustituye por un valor pequeño (épsilon) para poder continuar, y avisa con un mensaje. Si una fila completa da cero, también avisa (posibles raíces simétricas) para que se revise el resultado manualmente.
