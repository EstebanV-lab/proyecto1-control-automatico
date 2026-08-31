% ========================================================================
% PROYECTO CORTO #3
% DISENO DE COMPENSADORES POR LUGAR DE LAS RAICES
%
% El programa:
%   1. Recibe ceros y polos de la planta G(s).
%   2. Construye la funcion de transferencia.
%   3. Muestra la ecuacion caracteristica de la planta.
%   4. Dibuja el Root Locus ORIGINAL.
%   5. El usuario escribe por consola la ubicacion deseada del polo.
%   6. Calcula un compensador P, PI, PD o PID.
%   7. Muestra la nueva ecuacion caracteristica.
%   8. Dibuja un SEGUNDO Root Locus: el sistema COMPENSADO.
%   9. Despues de presionar ENTER, muestra la respuesta al escalon
%      del sistema original y del sistema compensado.
%
% Requiere: Control System Toolbox
% ========================================================================

clear;
clc;
close all;

fprintf('============================================================\n');
fprintf(' PROYECTO CORTO #3 - DISENO POR ROOT LOCUS\n');
fprintf('============================================================\n\n');

fprintf('Ejemplos de entrada:\n');
fprintf('  Ceros: []  o  [-2]\n');
fprintf('  Polos: [-1 -4]\n');
fprintf('  Polos complejos: [-2+3i -2-3i]\n\n');

%% =======================================================================
% 1. INGRESO DE CEROS Y POLOS
% ========================================================================

ceros = pedirVector('Ingrese los CEROS de G(s): ', true);
polos = pedirVector('Ingrese los POLOS de G(s): ', false);

if isempty(polos)
    error('La planta debe tener al menos un polo.');
end

if ~verificarConjugados(ceros)
    error('Los ceros complejos deben ingresarse en pares conjugados.');
end

if ~verificarConjugados(polos)
    error('Los polos complejos deben ingresarse en pares conjugados.');
end

%% =======================================================================
% 2. CONSTRUIR G(s)
% ========================================================================

numG = real(poly(ceros));
denG = real(poly(polos));

G = tf(numG, denG);

fprintf('\n============================================================\n');
fprintf(' FUNCION DE TRANSFERENCIA DE LA PLANTA G(s)\n');
fprintf('============================================================\n\n');

G

fprintf('============================================================\n');
fprintf(' ECUACION CARACTERISTICA DE LA PLANTA\n');
fprintf('============================================================\n\n');

fprintf('%s = 0\n\n', poly2str(denG, 's'));

fprintf('Con compensador C(s) y realimentacion unitaria:\n');
fprintf('1 + C(s)G(s) = 0\n\n');

%% =======================================================================
% 3. PRIMER ROOT LOCUS: PLANTA ORIGINAL
% ========================================================================

figure( ...
    'Name', 'Figura 1 - Root Locus original', ...
    'NumberTitle', 'off');

rlocus(G);
grid on;
sgrid;

title('Root Locus de la planta original G(s)');
xlabel('Parte real');
ylabel('Parte imaginaria');

drawnow;

% Sistema original en lazo cerrado
T_original = feedback(G, 1);

%% =======================================================================
% 4. CICLO DE DISENO
% ========================================================================

repetir = true;
intento = 0;

while repetir

    intento = intento + 1;

    fprintf('\n============================================================\n');
    fprintf(' DISENO DEL COMPENSADOR - INTENTO %d\n', intento);
    fprintf('============================================================\n\n');

    fprintf('Seleccione el tipo de compensador:\n\n');
    fprintf('  1) P    : C(s) = Kp\n');
    fprintf('  2) PI   : C(s) = Kp + Ki/s\n');
    fprintf('  3) PD   : C(s) = Kp + Kd*s\n');
    fprintf('  4) PID  : C(s) = Kp + Kd*s + Ki/s\n\n');

    tipo = pedirEntero('Opcion (1-4): ', 1, 4);

    %% ===================================================================
    % 5. POLO DESEADO POR CONSOLA
    % ====================================================================

    fprintf('\nIngrese la ubicacion deseada del polo dominante.\n');
    fprintf('Ejemplos: -2   o   -2+3i\n\n');

    sd = pedirEscalarComplejo('Polo deseado s_d = ');

    % Si se introduce el polo inferior, usar el conjugado superior
    if imag(sd) < 0

        sd = conj(sd);

        fprintf('\nSe utilizara el conjugado superior: %.4f %+.4fj\n', ...
            real(sd), imag(sd));

    end

    % Evaluar G(s) en el punto deseado
    Gsd = evalfr(G, sd);

    if abs(Gsd) < 1e-12
        error('El punto seleccionado coincide con un cero de G(s).');
    end

    % Condicion del lugar de las raices:
    %
    % 1 + C(sd)G(sd) = 0
    %
    % por lo tanto:
    %
    % C(sd) = -1/G(sd)

    Cnecesario = -1 / Gsd;

    Kp = NaN;
    Ki = NaN;
    Kd = NaN;

    %% ===================================================================
    % 6. CALCULO DEL COMPENSADOR
    % ====================================================================

    switch tipo

        % ---------------------------------------------------------------
        % P
        % ---------------------------------------------------------------
        case 1

            if abs(imag(Cnecesario)) < 1e-6 && ...
                    real(Cnecesario) >= 0

                Kp = real(Cnecesario);

                if Kp < 1e-10

                    fprintf('\nKp = 0 corresponde a la planta sin accion de control.\n');
                    fprintf('Seleccione otro polo deseado para observar compensacion.\n');

                    continue;

                end

                C = tf(Kp, 1);

                fprintf('\nCompensador P calculado:\n');
                fprintf('Kp = %.6g\n\n', Kp);

            else

                Kp = 1 / abs(Gsd);

                C = tf(Kp, 1);

                fprintf('\nAVISO:\n');
                fprintf('El polo indicado no pertenece exactamente al Root Locus\n');
                fprintf('de la planta para una ganancia proporcional positiva.\n');

                fprintf('Se utilizara la condicion de magnitud:\n');
                fprintf('Kp = %.6g\n\n', Kp);

            end

        % ---------------------------------------------------------------
        % PI
        % ---------------------------------------------------------------
        case 2

            if abs(imag(sd)) < 1e-8

                fprintf('\nPara PI seleccione un polo con parte imaginaria distinta de cero.\n');
                continue;

            end

            x = real(sd);
            y = imag(sd);

            r2 = x^2 + y^2;

            % C(s) = Kp + Ki/s

            Ki = -imag(Cnecesario) * r2 / y;

            Kp = real(Cnecesario) - Ki*x/r2;

            C = tf([Kp Ki], [1 0]);

            fprintf('\nCompensador PI calculado:\n');
            fprintf('Kp = %.6g\n', Kp);
            fprintf('Ki = %.6g\n\n', Ki);

        % ---------------------------------------------------------------
        % PD
        % ---------------------------------------------------------------
        case 3

            if abs(imag(sd)) < 1e-8

                fprintf('\nPara PD seleccione un polo con parte imaginaria distinta de cero.\n');
                continue;

            end

            x = real(sd);
            y = imag(sd);

            % C(s) = Kp + Kd*s

            Kd = imag(Cnecesario) / y;

            Kp = real(Cnecesario) - Kd*x;

            C = tf([Kd Kp], 1);

            fprintf('\nCompensador PD calculado:\n');
            fprintf('Kp = %.6g\n', Kp);
            fprintf('Kd = %.6g\n\n', Kd);

        % ---------------------------------------------------------------
        % PID
        % ---------------------------------------------------------------
        case 4

            if abs(imag(sd)) < 1e-8

                fprintf('\nPara PID seleccione un polo con parte imaginaria distinta de cero.\n');
                continue;

            end

            fprintf('\nPID tiene tres parametros: Kp, Ki y Kd.\n');
            fprintf('Se fija Ki y el programa calcula Kp y Kd.\n\n');

            Ki = pedirPositivo( ...
                'Ingrese el valor de Ki que desea fijar: ');

            x = real(sd);
            y = imag(sd);

            Crestante = Cnecesario - Ki/sd;

            Kd = imag(Crestante) / y;

            Kp = real(Crestante) - Kd*x;

            C = tf([Kd Kp Ki], [1 0]);

            fprintf('\nCompensador PID calculado:\n');
            fprintf('Kp = %.6g\n', Kp);
            fprintf('Ki = %.6g\n', Ki);
            fprintf('Kd = %.6g\n\n', Kd);

    end

    %% ===================================================================
    % 7. MOSTRAR C(s)
    % ====================================================================

    fprintf('============================================================\n');
    fprintf(' FUNCION DE TRANSFERENCIA DEL COMPENSADOR C(s)\n');
    fprintf('============================================================\n\n');

    C

    %% ===================================================================
    % 8. SISTEMA COMPENSADO Y ECUACION CARACTERISTICA
    % ====================================================================

    L = C * G;

    [numL, denL] = tfdata(L, 'v');

    caracteristica_comp = sumarPolinomios(denL, numL);

    caracteristica_comp = ...
        limpiarNumeros(caracteristica_comp);

    fprintf('============================================================\n');
    fprintf(' NUEVA ECUACION CARACTERISTICA DEL SISTEMA COMPENSADO\n');
    fprintf('============================================================\n\n');

    fprintf('%s = 0\n\n', ...
        poly2str(caracteristica_comp, 's'));

    % Sistema compensado en lazo cerrado
    T_comp = feedback(L, 1);

    polos_comp = pole(T_comp);

    fprintf('Polos del sistema compensado:\n\n');

    for n = 1:length(polos_comp)

        fprintf('  P%d = %.5f %+.5fj\n', ...
            n, ...
            real(polos_comp(n)), ...
            imag(polos_comp(n)));

    end

    % Comparar polo deseado con el polo obtenido
    [errorMin, idxPolo] = ...
        min(abs(polos_comp - sd));

    poloCercano = polos_comp(idxPolo);

    fprintf('\nPolo deseado              : %.5f %+.5fj\n', ...
        real(sd), imag(sd));

    fprintf('Polo obtenido mas cercano : %.5f %+.5fj\n', ...
        real(poloCercano), imag(poloCercano));

    fprintf('Error de ubicacion         : %.4e\n\n', ...
        errorMin);

    %% ===================================================================
    % 9. SEGUNDO ROOT LOCUS: SISTEMA COMPENSADO
    % ====================================================================

    figure( ...
        'Name', ...
        sprintf('Figura 2 - Root Locus compensado - intento %d', intento), ...
        'NumberTitle', 'off');

    rlocus(L);

    grid on;
    sgrid;
    hold on;

    % ---------------------------------------------------------------
    % Marcar polo deseado
    % ---------------------------------------------------------------

    plot( ...
        real(sd), ...
        imag(sd), ...
        'kp', ...
        'MarkerSize', 12, ...
        'MarkerFaceColor', 'y');

    % Marcar conjugado
    if abs(imag(sd)) > 1e-8

        plot( ...
            real(sd), ...
            -imag(sd), ...
            'kp', ...
            'MarkerSize', 12, ...
            'MarkerFaceColor', 'y');

    end

    % ---------------------------------------------------------------
    % Marcar polos realmente obtenidos
    % ---------------------------------------------------------------

    plot( ...
        real(polos_comp), ...
        imag(polos_comp), ...
        'rx', ...
        'MarkerSize', 10, ...
        'LineWidth', 2);

    title( ...
        sprintf( ...
        'Root Locus compensado C(s)G(s) - intento %d', ...
        intento));

    xlabel('Parte real');
    ylabel('Parte imaginaria');

    drawnow;

    fprintf('\n============================================================\n');
    fprintf(' SEGUNDO ROOT LOCUS GENERADO\n');
    fprintf('============================================================\n');

    input( ...
        ['Revise la grafica y presione ENTER para mostrar ', ...
         'la respuesta al escalon...'], ...
        's');

    %% ===================================================================
    % 10. RESPUESTA AL ESCALON
    % ====================================================================

    figure( ...
        'Name', ...
        sprintf('Figura 3 - Respuesta al escalon - intento %d', intento), ...
        'NumberTitle', 'off');

    step(T_original, T_comp);

    grid on;

    legend( ...
        'Sistema original', ...
        'Sistema compensado', ...
        'Location', 'best');

    title('Comparacion de la respuesta al escalon');

    xlabel('Tiempo (s)');
    ylabel('Amplitud');

    drawnow;

    %% ===================================================================
    % 11. REPETIR
    % ====================================================================

    respuesta = lower(strtrim(input( ...
        '\n¿Desea probar otro compensador con la misma planta? (s/n): ', ...
        's')));

    repetir = ...
        strcmp(respuesta, 's') || ...
        strcmp(respuesta, 'si');

end

fprintf('\n============================================================\n');
fprintf(' FIN DEL PROGRAMA\n');
fprintf('============================================================\n');


% ========================================================================
% FUNCIONES AUXILIARES
% ========================================================================

function v = pedirVector(mensaje, permitirVacio)

    while true

        texto = strtrim(input(mensaje, 's'));

        % Para ceros se acepta [] o simplemente ENTER
        if permitirVacio && ...
                (isempty(texto) || strcmp(texto, '[]'))

            v = [];
            return;

        end

        v = str2num(texto); %#ok<ST2NM>

        if ~isempty(v) && ...
                isnumeric(v) && ...
                isvector(v)

            v = v(:).';
            return;

        end

        fprintf('Entrada invalida.\n');
        fprintf('Ejemplo: [-1 -4] o [-2+3i -2-3i]\n');

        if permitirVacio
            fprintf('Si no existen valores, escriba [] o presione ENTER.\n');
        end

    end

end


function valor = pedirEscalarComplejo(mensaje)

    while true

        texto = strtrim(input(mensaje, 's'));

        valor = str2num(texto); %#ok<ST2NM>

        if ~isempty(valor) && ...
                isnumeric(valor) && ...
                isscalar(valor)

            return;

        end

        fprintf('Entrada invalida.\n');
        fprintf('Ejemplos: -2, -2+3i, -2-3i\n');

    end

end


function ok = verificarConjugados(v)

    tol = 1e-8;

    usados = false(size(v));

    ok = true;

    for i = 1:length(v)

        if usados(i)
            continue;
        end

        if abs(imag(v(i))) < tol

            usados(i) = true;
            continue;

        end

        encontrado = false;

        for j = 1:length(v)

            if i ~= j && ...
                    ~usados(j) && ...
                    abs(v(j) - conj(v(i))) < tol

                usados(i) = true;
                usados(j) = true;

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


function n = pedirEntero(mensaje, minimo, maximo)

    while true

        texto = strtrim(input(mensaje, 's'));

        n = str2double(texto);

        if ~isnan(n) && ...
                isscalar(n) && ...
                n >= minimo && ...
                n <= maximo && ...
                fix(n) == n

            return;

        end

        fprintf( ...
            'Ingrese un entero entre %d y %d.\n', ...
            minimo, ...
            maximo);

    end

end


function valor = pedirPositivo(mensaje)

    while true

        texto = strtrim(input(mensaje, 's'));

        valor = str2double(texto);

        if ~isnan(valor) && ...
                isreal(valor) && ...
                valor > 0

            return;

        end

        fprintf('Ingrese un numero real positivo.\n');

    end

end


function resultado = sumarPolinomios(a, b)

    n = max(length(a), length(b));

    a = [zeros(1, n-length(a)), a];

    b = [zeros(1, n-length(b)), b];

    resultado = a + b;

end


function p = limpiarNumeros(p)

    tol = 1e-10;

    p(abs(p) < tol) = 0;

end
