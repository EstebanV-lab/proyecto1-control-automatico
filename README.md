# proyecto1-control-automatico
# Proyecto Individual 1 — Laboratorio de Control Automático

## Descripción

Este proyecto implementa en MATLAB la simulación de un motor de corriente directa modelado como un sistema de primer orden:

[
G(s)=\frac{K_M}{\tau s+1}
]

donde:

[
K_M=\frac{K_t}{R_ab+K_tK_b}
]

[
\tau=\frac{R_aJ}{R_ab+K_tK_b}
]

El programa solicita los parámetros del motor, valida las entradas, calcula (K_M) y (\tau), genera la función de transferencia y grafica la respuesta al escalón unitario.

---

## Archivo principal

El script que debe ejecutarse es:

```text
proyecto1_motor_cd.m
```

---

## Requisitos

* MATLAB
* Control System Toolbox

---

## Ejecución

1. Abrir MATLAB.
2. Seleccionar como carpeta de trabajo la carpeta que contiene `proyecto1_motor_cd.m`.
3. Ejecutar en la **Command Window**:

```matlab
proyecto1_motor_cd
```

También se puede abrir el archivo en el editor de MATLAB y seleccionar **Run**.

---

## Parámetros de entrada

El programa solicita los siguientes parámetros:

* `Kt`: constante de par del motor ([N·m/A])
* `Ra`: resistencia de armadura ([\Omega])
* `b`: coeficiente de fricción del eje ([N·m·s/rad])
* `Kb`: constante de fuerza electromotriz ([V·s/rad])
* `J`: momento de inercia del motor y la carga ([kg·m^2])

Todos los valores deben ser **reales y positivos**.

Si se introduce un valor inválido, el programa lo rechaza y vuelve a solicitar el parámetro.

---

# Ejemplo de ejecución

Para verificar el funcionamiento del programa se puede utilizar el siguiente caso:

```text
Kt = 10
Ra = 1
b  = 0.1
Kb = 0.1
J  = 0.1
```

En la Command Window:

```text
Kt (constante de par del motor) [N*m/A]: 10
Ra (resistencia de armadura) [Ohm]: 1
b  (coeficiente de friccion del eje) [N*m*s/rad]: 0.1
Kb (constante de fuerza electromotriz) [V*s/rad]: 0.1
J  (momento de inercia motor+carga) [kg*m^2]: 0.1
```

Para estos valores:

[
K_M=\frac{10}{(1)(0.1)+(10)(0.1)}
]

[
K_M\approx9.0909
]

y:

[
\tau=\frac{(1)(0.1)}{(1)(0.1)+(10)(0.1)}
]

[
\tau\approx0.09091;s
]

Por lo tanto, la función de transferencia obtenida es:

[
G(s)=\frac{9.0909}{0.09091s+1}
]

---

## Resultados del caso de prueba

Los principales resultados obtenidos son aproximadamente:

| Parámetro                     | Resultado |
| ----------------------------- | --------: |
| (K_M)                         |    9.0909 |
| (\tau)                        | 0.09091 s |
| (y(\tau))                     |      5.75 |
| (5\tau)                       |  0.4545 s |
| (y(5\tau))                    |      9.03 |
| Tiempo de asentamiento al 2 % |   0.356 s |
| Error de estado estacionario  |   -8.0909 |

---

# Gráfica de respuesta

El programa genera automáticamente la respuesta del sistema ante un escalón unitario.

En la gráfica se identifican los elementos solicitados para el proyecto:

* **Curva azul:** respuesta (y(t)).
* **Línea roja:** valor final (K_M).
* **Punto magenta:** respuesta en (t=\tau).
* **Punto naranja:** respuesta en (t=5\tau).
* **Punto negro:** tiempo de asentamiento al 2 %.
* **Error de estado estacionario:** se muestra cuando es visible.

## Figura 1. Respuesta al escalón unitario

**Insertar aquí la captura de la gráfica generada por MATLAB.**

```text
[ FIGURA DE LA RESPUESTA AL ESCALÓN ]
```

**Figura 1.** Respuesta al escalón unitario para (K_t=10), (R_a=1), (b=0.1), (K_b=0.1) y (J=0.1). Se muestran el valor final, la respuesta en (t=\tau), la respuesta en (t=5\tau), el tiempo de asentamiento al 2 % y el error de estado estacionario.

---

## Salida del programa

Durante la ejecución se muestran en la Command Window:

* (K_M)
* (\tau)
* Función de transferencia (G(s))
* Respuesta en (t=\tau)
* Respuesta en (t=5\tau)
* Error de estado estacionario
* Tiempo de asentamiento al 2 %

Al finalizar se genera automáticamente la gráfica correspondiente.

---

## Validación de entradas

El programa rechaza entradas no válidas, por ejemplo:

```text
0
-1
abc
```

En estos casos se muestra:

```text
-> Valor invalido. Debe ingresar un numero real positivo.
```

y se vuelve a solicitar el parámetro.

---

## Funcionalidad implementada

El script realiza automáticamente:

1. Lectura de (K_t), (R_a), (b), (K_b) y (J).
2. Validación de los parámetros.
3. Cálculo de (K_M).
4. Cálculo de (\tau).
5. Construcción de (G(s)).
6. Simulación de la respuesta al escalón unitario.
7. Cálculo de (y(\tau)).
8. Cálculo de (y(5\tau)).
9. Cálculo del error de estado estacionario.
10. Cálculo del tiempo de asentamiento al 2 %.
11. Generación de la gráfica con los puntos requeridos.
