# Proyecto individual 1 - Simulación de motor de CD (sistema de primer orden)

**EL-5409 Laboratorio de Control Automático**
Instituto Tecnológico de Costa Rica — II Semestre 2026

## Descripción

Este script simula la respuesta al escalón unitario de un motor de CD modelado como un sistema de primer orden:

```
G(s) = KM / (τs + 1)
```

Los coeficientes `KM` (ganancia) y `τ` (constante de tiempo) se calculan a partir de 5 parámetros físicos del motor, en lugar de estar fijos en el código:

```
KM  = Kt / (Ra·b + Kt·Kb)
τ   = Ra·J / (Ra·b + Kt·Kb)
```

## Archivo principal

[`script/SistControl_MotorDC.m`](script/SistControl_MotorDC.m) — script único, autocontenido, con comentarios línea por línea.

## Requisitos

- **MATLAB** con Control System Toolbox instalado, **o**
- **GNU Octave** con el paquete `control` instalado:
  ```
  pkg install -forge control
  pkg load control
  ```
  (en MATLAB no se necesita ningún `pkg load`, el toolbox ya viene integrado)

## Cómo ejecutar el script

1. Abrí MATLAB u Octave y ubicá la carpeta actual (`Current Folder`) en la carpeta `script/`, donde está `SistControl_MotorDC.m`.
2. Ejecutá el script (`F5` en MATLAB, o escribiendo `SistControl_MotorDC` en la consola de Octave).
3. El programa va a pedir, en este orden, los 5 parámetros del motor:

| Parámetro | Descripción | Unidades |
|---|---|---|
| `Kt` | Constante de par del motor | N·m/A |
| `Ra` | Resistencia de armadura | Ω |
| `b`  | Coeficiente de fricción del eje | N·m·s/rad |
| `Kb` | Constante de fuerza electromotriz | V·s/rad |
| `J`  | Momento de inercia (motor + carga) | kg·m² |

4. Cada valor se valida como número real positivo. Si se ingresa texto, cero, un negativo o un número complejo, el script vuelve a pedir el dato sin detenerse.

## Salida del programa

**En consola** se imprimen:
- `KM` y `τ` calculados.
- La función de transferencia `G(s)`.
- El valor final esperado del sistema (en t = 5τ).
- El error de estado estacionario respecto a una referencia unitaria.
- El valor de la respuesta en t = τ.
- El tiempo de asentamiento real al 2% (calculado dinámicamente, no aproximado).

**En una ventana gráfica** se muestra la curva de respuesta al escalón unitario, con las siguientes marcas:

| Color | Elemento |
|---|---|
| Rojo (línea punteada) | Valor final esperado del sistema |
| Verde (cuadrado) | Punto en t = 5τ |
| Naranja (círculo) | Punto en t = τ (≈63.2% del valor final) |
| Negro (triángulo) | Tiempo de asentamiento al 2% |
| Verde (línea vertical, solo si es visible) | Error de estado estacionario |

## Ejemplo de prueba

Con los siguientes valores de un motor de CD pequeño:

```
Kt = 0.01
Ra = 1
b  = 0.001
Kb = 0.01
J  = 0.0001
```

Se obtiene `KM ≈ 9.09`, `τ ≈ 0.0909 s`, y un tiempo de asentamiento de aproximadamente `0.356 s`.

## Notas

- El error de estado estacionario se calcula como `1 - KM`. Si `KM` está lejos de 1, ese error va a ser grande — esto es esperado, ya que el script simula el motor en lazo abierto (sin controlador), no un sistema realimentado.
- El tiempo de asentamiento se calcula de forma exacta (primer instante en que la respuesta entra y permanece dentro del ±2% del valor final), no se aproxima con una regla fija como `4τ`.
