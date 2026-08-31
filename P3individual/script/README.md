## Autor

**Esteban Vargas Fernández**  
Carné: **2023395790**

## Curso

**EL-5409 Laboratorio de Control Automático**

# Proyecto Individual 3 — Diseño de compensadores por Root Locus

Este proyecto implementa en **MATLAB** un programa para analizar una planta a partir de sus polos y ceros, diseñar compensadores **P, PI, PD y PID**, visualizar el **lugar de las raíces** antes y después de la compensación y comparar la respuesta al escalón del sistema original con la del sistema compensado.

## Archivo principal

El programa principal se encuentra en:

```text
compensador.m
```

## Requisitos

Para ejecutar el proyecto se necesita:

- MATLAB.
- Control System Toolbox.
- El archivo `compensador.m`.

## Ejecución

1. Abra MATLAB.
2. Navegue hasta la carpeta donde se encuentra `compensador.m`.
3. Abra el archivo en el editor de MATLAB.
4. Presione **Run**.

También puede ejecutarlo directamente desde la **Command Window** con:

```matlab
compensador
```

## Uso del programa

Al iniciar, el programa solicita los **ceros** y **polos** de la planta.

Por ejemplo, para:

\[
G(s)=\frac{1}{(s+1)(s+4)}
\]

se deben ingresar:

```text
Ingrese los CEROS de G(s): []
Ingrese los POLOS de G(s): [-1 -4]
```

Si la planta no tiene ceros, se puede escribir:

```text
[]
```

Si existen polos o ceros complejos, deben ingresarse en pares conjugados. Por ejemplo:

```text
[-2+3i -2-3i]
```

## Flujo del programa

Después de ingresar la planta, el programa realiza el siguiente proceso:

1. Construye la función de transferencia \(G(s)\).
2. Muestra la ecuación característica de la planta.
3. Genera el **Root Locus original**.
4. Solicita el tipo de compensador:
   - `1` — P
   - `2` — PI
   - `3` — PD
   - `4` — PID
5. Solicita la ubicación deseada del polo dominante.
6. Calcula los parámetros del compensador.
7. Muestra la función de transferencia \(C(s)\).
8. Obtiene la nueva ecuación característica.
9. Genera un **segundo Root Locus** correspondiente al sistema compensado \(C(s)G(s)\).
10. Después de presionar **Enter**, muestra la comparación de la respuesta al escalón.
11. Permite realizar otro diseño utilizando la misma planta.

## Ejemplo de prueba

Utilizando:

```text
CEROS: []
POLOS: [-1 -4]
```

### Compensador P

Seleccione:

```text
Opcion: 1
Polo deseado: -2.5+0.8660254i
```

Resultado aproximado:

```text
Kp = 3
```

### Compensador PI

Seleccione:

```text
Opcion: 2
Polo deseado: -1+2i
```

Resultado aproximado:

```text
Kp = 7
Ki = 15
```

### Compensador PD

Seleccione:

```text
Opcion: 3
Polo deseado: -3+2i
```

Resultado aproximado:

```text
Kp = 9
Kd = 1
```

### Compensador PID

Seleccione:

```text
Opcion: 4
Polo deseado: -3+2i
Ki = 13
```

Resultado aproximado:

```text
Kp = 15
Ki = 13
Kd = 2
```

## Gráficas generadas

El programa genera tres tipos de gráficas:

### Root Locus original

Muestra el lugar de las raíces de la planta \(G(s)\) antes de aplicar el compensador.

### Root Locus compensado

Muestra el lugar de las raíces de:

\[
C(s)G(s)
\]

También se indican la ubicación deseada del polo y los polos obtenidos para el sistema compensado.

### Respuesta al escalón

Compara:

- Sistema original.
- Sistema compensado.

Esta gráfica permite observar cambios en la rapidez de respuesta, sobreimpulso, oscilaciones y error de estado estacionario.

## Observaciones

- Para los compensadores PI, PD y PID se recomienda utilizar polos deseados con parte imaginaria distinta de cero, por ejemplo:

```text
-3+2i
```

- En el caso PID se fija inicialmente \(K_i\), y el programa calcula \(K_p\) y \(K_d\).
- Si una ubicación seleccionada no pertenece al lugar de las raíces alcanzable mediante un compensador P, el programa muestra una advertencia.
- Para realizar otra prueba con la misma planta, responda:

```text
s
```

cuando aparezca:

```text
¿Desea probar otro compensador con la misma planta? (s/n):
```

Para finalizar, responda:

```text
n
```


