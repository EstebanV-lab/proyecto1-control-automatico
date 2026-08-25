% ====================================================================
% Estudiante: Esteban Vargas Fernández
% Carné: 2023395790
%
% EL-5409 Laboratorio de Control Automatico - Proyecto individual 1
% Simulacion parametrica de la respuesta al escalon unitario de un
% motor de CD modelado como sistema de primer orden:
%
%       G(s) = KM / (tau*s + 1)
%
%       KM  = Kt / (Ra*b + Kt*Kb)
%       tau = Ra*J / (Ra*b + Kt*Kb)
%
% ====================================================================

clear all; clc; close all;

fprintf('=== Simulacion de motor de CD (sistema de primer orden) ===\n\n');

% --------------------------------------------------------------
% 1. Parametros de entrada: Kt, Ra, b, Kb, J
% --------------------------------------------------------------
% Se piden por linea de comandos y se validan (numero real positivo).
% Si el usuario ingresa un valor invalido, se le vuelve a pedir.

Kt = pedir_parametro_positivo('Kt (constante de par del motor) [N*m/A]: ');
Ra = pedir_parametro_positivo('Ra (resistencia de armadura) [Ohm]: ');
b  = pedir_parametro_positivo('b  (coeficiente de friccion del eje) [N*m*s/rad]: ');
Kb = pedir_parametro_positivo('Kb (constante de fuerza electromotriz) [V*s/rad]: ');
J  = pedir_parametro_positivo('J  (momento de inercia motor+carga) [kg*m^2]: ');

denominador = Ra*b + Kt*Kb;

if denominador <= 0
    error(['Combinacion de parametros invalida: ', ...
           'Ra*b + Kt*Kb debe ser mayor que cero.']);
end

% --------------------------------------------------------------
% 2. Calculo de KM y tau
% --------------------------------------------------------------

K = Kt / denominador;        % KM
T = (Ra*J) / denominador;    % tau

fprintf('\n--- Resultados ---\n');
fprintf('KM  (ganancia del sistema)      = %.6g\n', K);
fprintf('tau (constante de tiempo) [s]   = %.6g\n', T);

% --------------------------------------------------------------
% 3. Definicion de la funcion de transferencia G(s)
% --------------------------------------------------------------

num = [K];
den = [T, 1];

G = tf(num, den);

disp('Funcion de Transferencia Obtenida G(s):');
G

% --------------------------------------------------------------
% 4. Vector de tiempo y respuesta al escalon unitario
% --------------------------------------------------------------

% Se simula hasta 6*tau para poder observar claramente el punto
% correspondiente a t = 5*tau.

t_final = 6 * T;

% Se utiliza linspace para mantener buena resolucion incluso si tau
% cambia considerablemente entre diferentes motores.
t = linspace(0, t_final, 6001);

[y, t] = step(G, t);

% Asegurar vectores columna
y = y(:);
t = t(:);

% --------------------------------------------------------------
% 5. Calculo de los 4 elementos requeridos
% --------------------------------------------------------------

% ==============================================================
% a) Valor final esperado y respuesta en t = 5*tau
% ==============================================================

t_5T = 5 * T;

% Valor final teorico de la respuesta
valor_final = K;

% Respuesta exacta de un sistema de primer orden:
%
% y(t) = K*(1 - exp(-t/T))
%
% Para t = 5*T:
y_5T = K * (1 - exp(-5));

% ==============================================================
% b) Error de estado estacionario
% ==============================================================

% Para una entrada escalon unitario, la referencia es igual a 1.
error_ess = 1 - valor_final;

% ==============================================================
% c) Valor de la respuesta en t = tau
% ==============================================================

% Para t = T:
%
% y(T) = K*(1 - exp(-1))
%
% lo que corresponde aproximadamente al 63.2 % del valor final.

y_T = K * (1 - exp(-1));

% ==============================================================
% d) Tiempo de asentamiento real al 2 %
% ==============================================================

% Banda de tolerancia del 2 % alrededor del valor final.
tolerancia = 0.02 * abs(valor_final);

% Se busca desde el final de la simulacion hacia atras el ultimo
% instante en el que la respuesta se encontraba fuera de la banda.
idx_asent = length(y);

for k = length(y):-1:1

    if abs(y(k) - valor_final) > tolerancia
        idx_asent = k + 1;
        break;
    end

end


if idx_asent > length(t)
    idx_asent = length(t);
end

% Tiempo de asentamiento.
t_asentamiento = t(idx_asent);

% IMPORTANTE:
% Se toma el valor REAL de la curva en el tiempo de asentamiento.
% De esta forma, el punto se dibuja exactamente sobre la respuesta.
y_asentamiento = y(idx_asent);

% --------------------------------------------------------------
% Mostrar resultados numericos
% --------------------------------------------------------------

fprintf('\n--- Caracteristicas de la respuesta ---\n');

fprintf('Valor final esperado KM          = %.6g\n', ...
        valor_final);

fprintf('t = 5*tau = %.6g s, y(t) = %.6g\n', ...
        t_5T, y_5T);

fprintf('Error de estado estacionario     = %.6g\n', ...
        error_ess);

fprintf('t = tau = %.6g s, y(t) = %.6g\n', ...
        T, y_T);

fprintf('Tiempo de asentamiento (2%%)      = %.6g s\n', ...
        t_asentamiento);

fprintf('y(t_asentamiento)                = %.6g\n', ...
        y_asentamiento);

% --------------------------------------------------------------
% 6. Graficacion con formato didactico
% --------------------------------------------------------------

figure('Name', ...
       'Respuesta al Escalon - Motor de CD (1er orden)', ...
       'NumberTitle', 'off');

hold on;
grid on;
box on;

% ==============================================================
% Curva principal de respuesta
% ==============================================================

h_respuesta = plot(t, y, ...
                   'b-', ...
                   'LineWidth', 2);

% ==============================================================
% a) Valor final esperado KM
% ==============================================================

h_final = line([0 t_final], ...
               [valor_final valor_final], ...
               'Color', 'r', ...
               'LineStyle', '--', ...
               'LineWidth', 1.5);

% ==============================================================
% a) Punto en t = 5*tau
% ==============================================================

% Color naranja RGB
color_naranja = [1.0 0.5 0.0];

% Linea vertical naranja
line([t_5T t_5T], ...
     [0 y_5T], ...
     'Color', color_naranja, ...
     'LineStyle', ':', ...
     'LineWidth', 1.2, ...
     'HandleVisibility', 'off');

% Punto naranja sobre la curva
h_5T = plot(t_5T, y_5T, ...
            'o', ...
            'MarkerSize', 9, ...
            'MarkerFaceColor', color_naranja, ...
            'MarkerEdgeColor', color_naranja);

% ==============================================================
% c) Punto en t = tau
% ==============================================================

% Se utiliza magenta
color_tau = [1 0 1];

% Linea vertical
line([T T], ...
     [0 y_T], ...
     'Color', color_tau, ...
     'LineStyle', ':', ...
     'LineWidth', 1.2, ...
     'HandleVisibility', 'off');

% Linea horizontal hacia la curva
line([0 T], ...
     [y_T y_T], ...
     'Color', color_tau, ...
     'LineStyle', ':', ...
     'LineWidth', 1.0, ...
     'HandleVisibility', 'off');

% Punto de t = tau
h_T = plot(T, y_T, ...
           '^', ...
           'MarkerSize', 9, ...
           'MarkerFaceColor', color_tau, ...
           'MarkerEdgeColor', color_tau);

% ==============================================================
% d) Punto del tiempo de asentamiento real al 2 %
% ==============================================================

% Linea vertical negra hasta el punto real sobre la curva
line([t_asentamiento t_asentamiento], ...
     [0 y_asentamiento], ...
     'Color', 'k', ...
     'LineStyle', ':', ...
     'LineWidth', 1.2, ...
     'HandleVisibility', 'off');

% Punto NEGRO exactamente sobre la curva
h_asentamiento = plot(t_asentamiento, ...
                      y_asentamiento, ...
                      'o', ...
                      'MarkerSize', 9, ...
                      'MarkerFaceColor', 'k', ...
                      'MarkerEdgeColor', 'k');

% ==============================================================
% b) Error de estado estacionario
% ==============================================================

% Solo se muestra cuando el error es visible.
if abs(error_ess) > 1e-6

    line([t_final t_final], ...
         [valor_final 1], ...
         'Color', 'g', ...
         'LineWidth', 2, ...
         'HandleVisibility', 'off');

    text(t_final, ...
         (valor_final + 1)/2, ...
         sprintf('  e_{ss}=%.3g', error_ess), ...
         'Color', 'g', ...
         'HorizontalAlignment', 'left');

end

% --------------------------------------------------------------
% 7. Titulos y etiquetas
% --------------------------------------------------------------

title(['Respuesta al Escalon Unitario: G(s) = ', ...
       num2str(K), ...
       ' / (', ...
       num2str(T), ...
       's + 1)'], ...
       'FontSize', 12);

xlabel('Tiempo (s)', 'FontSize', 11);
ylabel('Respuesta y(t)', 'FontSize', 11);

% --------------------------------------------------------------
% 8. Leyenda
% --------------------------------------------------------------


legend([h_respuesta, ...
        h_final, ...
        h_5T, ...
        h_T, ...
        h_asentamiento], ...
       { ...
       'Respuesta y(t)', ...
       ['Valor final (KM = ', num2str(K, '%.4f'), ')'], ...
       ['t = 5tau, y(t) = ', num2str(y_5T, '%.2f')], ...
       ['t = tau, y(t) = ', num2str(y_T, '%.2f')], ...
       ['t asentamiento 2% = ', ...
        num2str(t_asentamiento, '%.3f'), ...
        ' s, y(t) = ', ...
        num2str(y_asentamiento, '%.2f')] ...
       }, ...
       'Location', 'southeast');

% --------------------------------------------------------------
% 9. Limites de la grafica
% --------------------------------------------------------------

xlim([0 t_final]);

hold off;

fprintf('\nListo. Revise la figura generada.\n');

% ====================================================================
% Funcion auxiliar de validacion de entrada
% ====================================================================

function valor = pedir_parametro_positivo(mensaje)

    valor = [];

    while isempty(valor)

        entrada = input(mensaje, 's');
        num = str2double(entrada);

        if isnan(num) || ~isreal(num) || num <= 0

            fprintf(['  -> Valor invalido. ', ...
                     'Debe ingresar un numero real positivo.\n']);

        else

            valor = num;

        end

    end

end
