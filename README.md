# Proyecto individual 1 - Simulación de motor de CD (sistema de primer orden)

**EL-5409 Laboratorio de Control Automático**
Estudiante: Esteban Vargas Fernández — Carné: 2023395790

## Archivo

[`script/SistControl_MotorDC.m`](script/SistControl_MotorDC.m)

## Uso

1. Abrir MATLAB u Octave, ubicar la carpeta actual en `script/`.
2. Ejecutar el archivo (`F5` en MATLAB, o `SistControl_MotorDC` en Octave).
3. El script pide, en este orden, 5 parámetros del motor (todos números reales positivos; si se ingresa un valor inválido, se vuelve a pedir):

| Parámetro | Descripción | Unidades |
|---|---|---|
| `Kt` | Constante de par del motor | N·m/A |
| `Ra` | Resistencia de armadura | Ω |
| `b`  | Coeficiente de fricción del eje | N·m·s/rad |
| `Kb` | Constante de fuerza electromotriz | V·s/rad |
| `J`  | Momento de inercia (motor + carga) | kg·m² |

## Salida

**Consola:** KM, τ, la función de transferencia G(s), el valor de la respuesta en t=5τ, el error de estado estacionario, el valor en t=τ, y el tiempo de asentamiento real al 2% (con su valor exacto sobre la curva).

**Gráfico:** respuesta al escalón unitario con 4 marcas, cada una con su valor numérico en la leyenda:

| Color | Punto |
|---|---|
| Rojo (línea punteada) | Valor final esperado (KM) |
| Naranja (círculo) | t = 5τ |
| Magenta (triángulo) | t = τ (≈63.2% del valor final) |
| Negro (círculo) | Tiempo de asentamiento al 2% |
| Verde (línea, solo si es visible) | Error de estado estacionario |

## Requisitos

- MATLAB con Control System Toolbox, o
- GNU Octave con `pkg install -forge control` + `pkg load control`

## Nota

El error de estado estacionario (`1 - KM`) puede ser grande si KM está lejos de 1; es esperado, ya que el motor se simula en lazo abierto, sin controlador.
