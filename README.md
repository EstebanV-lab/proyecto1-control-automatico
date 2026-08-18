Hola.
Puede por favor agregar su nombre completo y su numero de ID?
Gracias.

Luis C. Rosales A.
-----------------

Estudiante: Esteban Vargas Fernández.
Carné: 2023395790.

# Proyecto individual 1 - Simulación de motor de CD (sistema de primer orden)

**EL-5409 Laboratorio de Control Automático**
Estudiante: Esteban Vargas Fernández — Carné: 2023395790

## Archivo

[`script/SistControl_MotorDC.m`](script/SistControl_MotorDC.m)

## Paso a paso para ejecutar el script

1. **Ubicate en la carpeta correcta.** Abrí MATLAB. En el panel "Current Folder" (arriba), navegá hasta la carpeta `script/` de este repositorio, donde está `SistControl_MotorDC.m`.
2. **Abrí el archivo.** Doble clic sobre `SistControl_MotorDC.m` en el panel "Current Folder" para abrirlo en el Editor.
3. **Ejecutá el script.** Con el archivo abierto, presioná `F5` o el botón verde ▶ "Run". Si aparece "Change Folder or Add to Path", hacé clic en "Change Folder".
4. **Respondé las 5 preguntas en la Command Window**, en este orden exacto, escribiendo un número y dando Enter en cada una:
   - `Kt` (constante de par del motor) [N·m/A]
   - `Ra` (resistencia de armadura) [Ω]
   - `b` (coeficiente de fricción del eje) [N·m·s/rad]
   - `Kb` (constante de fuerza electromotriz) [V·s/rad]
   - `J` (momento de inercia motor+carga) [kg·m²]
5. **Si te equivocás al escribir** (texto, cero, un negativo), la consola dice "Valor inválido. Debe ingresar un número real positivo." y te repite la misma pregunta hasta que ingreses un valor aceptable.
6. **Leé los resultados en la consola**: apenas completás las 5 preguntas, se imprimen automáticamente KM, τ, la función de transferencia G(s), el valor en t=5τ, el error de estado estacionario, el valor en t=τ, y el tiempo de asentamiento real al 2%.
7. **Revisá la ventana de gráfico** que se abre en paralelo: "Respuesta al Escalón - Motor de CD (1er orden)", con la curva y las 4 marcas de color más sus valores en la leyenda.

Para volver a correrlo con otros parámetros, simplemente presioná `F5` de nuevo — el script limpia variables, consola y gráficos anteriores automáticamente al iniciar.

## Salida

**Consola:** KM, τ, G(s), valor en t=5τ, error de estado estacionario, valor en t=τ, y tiempo de asentamiento al 2% (con su valor real sobre la curva).

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

Si MATLAB da un error tipo `Undefined function 'tf'`, revisá con el comando `ver` que el Control System Toolbox esté instalado.

## Nota

El error de estado estacionario (`1 - KM`) puede ser grande si KM está lejos de 1; es esperado, ya que el motor se simula en lazo abierto, sin controlador.
