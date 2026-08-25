% ====================================================================
% Estudiante: Esteban Vargas Fernández
% Carné: 2023395790
%
% EL-5409 Laboratorio de Control Automatico - Proyecto individual 2
% Simulacion parametrica del metodo de Routh-Hurwitz (tabla en cascada)
% y del lugar de las raices (root locus) para una funcion de
% transferencia G(s) dada por sus ceros y polos de lazo abierto.
%
% Ecuacion caracteristica de lazo cerrado: 1 + K*G(s) = 0
% ====================================================================

clear all; clc; close all;

fprintf('=== Analisis de estabilidad: Routh-Hurwitz y Root Locus ===\n\n');

% --------------------------------------------------------------
% 1. Solicitar los ceros y polos de G(s) en lazo abierto
% --------------------------------------------------------------
% Se piden como vectores (pueden incluir numeros complejos conjugados,
% o quedar vacios [] en el caso de los ceros). pedir_vector_conjugado
% valida que la entrada sea un vector numerico valido Y que cualquier
% valor complejo venga acompañado de su conjugado (si no, el sistema
% no seria fisicamente real y el root locus no se podria calcular).

fprintf('Ingrese los valores entre corchetes cuadrados [ ]\n\n');

zeros_G = pedir_vector_conjugado(['Ingrese los CEROS de G(s) separados por un espacio ', ...
    '(ej: [-2 -2+3i -2-3i -2i] o [] si no tiene): ']);
polos_G = pedir_vector_conjugado(['Ingrese los POLOS de G(s) como vector fila separados por un espacio ', ...
    '(ej: [-1 -2+3i -2-3i -2i]): ']);

if isempty(polos_G)
    error('El sistema debe tener al menos un polo.');
end

% Ganancia de lazo cerrado que se desea evaluar con Routh-Hurwitz.
K = pedir_parametro_positivo('Ingrese el valor de K (ganancia de lazo cerrado) a evaluar: ');

% --------------------------------------------------------------
% 2. Construir G(s) = N(s)/D(s) a partir de los ceros y polos
% --------------------------------------------------------------
% poly() convierte un conjunto de raices en los coeficientes del
% polinomio que las tiene como raices (orden: potencia mayor primero).

num = poly(zeros_G);   % N(s): numerador de G(s)
den = poly(polos_G);   % D(s): denominador de G(s)
G = tf(num, den);

disp('Funcion de transferencia de lazo abierto G(s):');
G

% --------------------------------------------------------------
% 3. Ecuacion caracteristica de lazo cerrado: 1 + K*G(s) = 0
% --------------------------------------------------------------
% Equivale a D(s) + K*N(s) = 0. Como N(s) puede tener menor grado que
% D(s), se rellena con ceros a la izquierda para poder sumarlos termino
% a termino (alinear las potencias de s).

n_den = length(den);
n_num = length(num);
num_alineado = [zeros(1, n_den - n_num), num];

char_eq = den + K*num_alineado;

% Limpieza de residuos numericos imaginarios (deberian ser ~0 si los
% ceros/polos complejos se ingresaron en pares conjugados; si no,
% la ecuacion caracteristica no seria fisicamente valida).
if max(abs(imag(char_eq))) > 1e-9
    warning(['La ecuacion caracteristica tiene coeficientes complejos. ', ...
        'Verifique que los polos/ceros complejos se hayan ingresado en pares conjugados.']);
end
char_eq = real(char_eq);

% El criterio de Hurwitz requiere que el coeficiente principal sea
% positivo; si no lo es, se multiplica toda la ecuacion por -1
% (esto no cambia las raices del sistema).
if char_eq(1) < 0
    char_eq = -char_eq;
end

fprintf('\nEcuacion caracteristica de lazo cerrado (K = %.4g):\n', K);
disp(poly2str(char_eq, 's'));

% --------------------------------------------------------------
% 4. Tabla de Routh y evaluacion de estabilidad
% --------------------------------------------------------------
% Se construye la tabla de Routh siguiendo el metodo clasico de 4 pasos:
%   1) Primera columna con s^n en orden decreciente.
%   2) Primera fila con los coeficientes de indice par (a0, a2, a4, ...).
%   3) Segunda fila con los coeficientes de indice impar (a1, a3, a5, ...).
%   4) Filas siguientes con el calculo cruzado, rellenando con ceros
%      donde haga falta.
% El sistema es estable si NINGUN valor de la primera columna cambia
% de signo al bajar por la tabla (no hace falta calcular determinantes).

[T, potencias] = tabla_routh(char_eq);

fprintf('\nTabla de Routh:\n');
for f = 1:size(T,1)
    fprintf('  s^%-2d | ', potencias(f));
    fprintf('%10.4g', T(f,:));
    fprintf('\n');
end

primera_columna = T(:,1);
cambios_signo = sum(diff(sign(primera_columna)) ~= 0);
es_estable = (cambios_signo == 0);

fprintf('\n--- Conclusion ---\n');
if es_estable
    fprintf('El sistema es ESTABLE para K = %.4g\n', K);
    fprintf('Justificacion: la primera columna de la tabla de Routh no cambia de signo,\n');
    fprintf('por lo tanto todas las raices de la ecuacion caracteristica tienen parte real negativa.\n');
else
    fprintf('El sistema es INESTABLE para K = %.4g\n', K);
    fprintf('Justificacion: la primera columna de la tabla de Routh cambia de signo %d vez(veces),\n', cambios_signo);
    fprintf('por lo tanto hay %d raiz(raices) con parte real positiva (semiplano derecho).\n', cambios_signo);
end

% --------------------------------------------------------------
% 5. Grafico del lugar de las raices (root locus)
% --------------------------------------------------------------
% rlocus(G) grafica automaticamente el lugar de las raices de G(s) a
% medida que K varia de 0 a infinito, marcando los polos de lazo
% abierto con 'x' y los ceros de lazo abierto con 'o' (comportamiento
% por defecto de la funcion, no requiere codigo adicional).

figure('Name', 'Root Locus - G(s)', 'NumberTitle', 'off');
rlocus(G);
hold on;
grid on;

% Se calculan y se marcan ademas los polos de LAZO CERRADO para el
% valor de K ingresado, como verificacion visual de la estabilidad.
polos_lazo_cerrado = roots(char_eq);
h_pts = plot(real(polos_lazo_cerrado), imag(polos_lazo_cerrado), ...
             'ks', 'MarkerSize', 10, 'MarkerFaceColor', 'y');

title(sprintf('Root Locus de G(s) (x=polos, o=ceros de lazo abierto); K=%.4g', K));
legend(h_pts, sprintf('Polos de lazo cerrado en K=%.4g', K), 'Location', 'best');

fprintf('\nListo. Revise la figura del root locus.\n');

% ====================================================================
% Funciones auxiliares (deben ir al final del script en MATLAB)
% ====================================================================

% Pide un numero real positivo por consola, repitiendo hasta que sea valido.
function valor = pedir_parametro_positivo(mensaje)
    valor = [];
    while isempty(valor)
        entrada = input(mensaje, 's');
        num = str2double(entrada);
        if isnan(num) || ~isreal(num) || num <= 0
            fprintf('  -> Valor invalido. Debe ingresar un numero real positivo.\n');
        else
            valor = num;
        end
    end
end

% Pide un vector y lo vuelve a pedir si algun valor complejo no tiene
% su conjugado dentro del mismo vector (ver verificar_conjugados).
function v = pedir_vector_conjugado(mensaje)
    valido = false;
    while ~valido
        v = pedir_vector_numerico(mensaje);
        if verificar_conjugados(v)
            valido = true;
        else
            fprintf(['  -> Los valores complejos deben venir en pares conjugados ', ...
                '(ej: -2+3i junto con -2-3i). Intente de nuevo.\n']);
        end
    end
end

% Revisa que cada valor complejo del vector tenga su conjugado tambien
% presente en el mismo vector (condicion necesaria para que G(s) tenga
% coeficientes reales, como corresponde a un sistema fisico real).
function ok = verificar_conjugados(v)
    tol = 1e-9;
    usado = false(size(v));
    ok = true;
    for i = 1:length(v)
        if usado(i)
            continue;
        end
        if abs(imag(v(i))) < tol
            usado(i) = true;   % valor real, no necesita pareja
            continue;
        end
        encontrado = false;
        for j = 1:length(v)
            if j == i || usado(j)
                continue;
            end
            if abs(v(j) - conj(v(i))) < tol
                usado(j) = true;
                usado(i) = true;
                encontrado = true;
                break;
            end
        end
        if ~encontrado
            ok = false;
            return;
        end
    end
end

% Pide un vector numerico (real o complejo) por consola. Se usa input()
% sin la bandera 's' para que MATLAB evalue directamente expresiones
% como [-1 -2] o [-1+2i -1-2i] o [] (vector vacio, valido para ceros).
function v = pedir_vector_numerico(mensaje)
    valido = false;
    while ~valido
        entrada = input(mensaje);
        if isnumeric(entrada) && (isvector(entrada) || isempty(entrada))
            v = entrada;
            valido = true;
        else
            fprintf('  -> Entrada invalida. Ingrese un vector numerico, ej: [-1 -2] o [].\n');
        end
    end
end

% Construye la tabla de Routh siguiendo el metodo clasico de 4 pasos
% (ver comentario en la seccion 4). coefs = [a0 a1 ... an], potencia
% mayor primero. Devuelve la tabla T y el vector de potencias de s
% que etiqueta cada fila (n, n-1, ..., 0), solo para imprimir bonito.
function [T, potencias] = tabla_routh(coefs)
    n = length(coefs) - 1;          % grado de la ecuacion caracteristica
    m = ceil((n + 1) / 2);          % columnas necesarias

    T = zeros(n + 1, m);
    potencias = n:-1:0;

    % Paso 2: primera fila con los coeficientes de indice par (a0,a2,a4,...)
    fila1 = coefs(1:2:end);
    T(1, 1:length(fila1)) = fila1;

    % Paso 3: segunda fila con los coeficientes de indice impar (a1,a3,a5,...)
    if n >= 1
        fila2 = coefs(2:2:end);
        T(2, 1:length(fila2)) = fila2;
    end

    % Paso 4: filas siguientes, con el calculo cruzado clasico de Routh.
    % Cada valor nuevo usa las dos filas justo arriba de el.
    for r = 3:n+1
        pivote = T(r-1, 1);

        % Caso especial: si el pivote da cero, no se puede dividir.
        % Se sustituye por un numero muy pequeno (epsilon) para poder
        % seguir construyendo la tabla (metodo estandar para este caso).
        if pivote == 0
            pivote = 1e-6;
            T(r-1, 1) = pivote;
            warning('Pivote cero en la fila s^%d; se sustituyo por epsilon para continuar.', potencias(r-1));
        end

        for j = 1:m-1
            T(r, j) = (T(r-1,1)*T(r-2,j+1) - T(r-2,1)*T(r-1,j+1)) / pivote;
        end
        T(r, m) = 0;   % ultima columna: se rellena con cero

        if all(T(r, 1:m-1) == 0)
            warning('La fila s^%d salio completamente en cero (posibles raices simetricas); revise el resultado manualmente.', potencias(r));
        end
    end
end
