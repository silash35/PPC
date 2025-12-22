close all
clc

%% Leitura dos dados
dados = readtable('data/simulation_deviation.csv');   % nome do arquivo CSV

t     = dados.t;
m_dot = dados.m_dot;
Pp    = dados.Pp;
N     = dados.N;
alpha = dados.alpha;

%% Parâmetros
Ts = mean(0.1);   % intervalo de amostragem estimado a partir do tempo

%% Definição de entrada e saída
y = Pp;                 % saída (ASSUMIDO)
u = [N alpha];          % entradas múltiplas

%% Separação em dados de estimação e validação
N_est = floor(length(y)*0.5);

ze = iddata(y(1:N_est), u(1:N_est,:), Ts);
zv = iddata(y(N_est+1:end), u(N_est+1:end,:), Ts);

%% Estrutura do modelo
estrutura = idproc('P2'); 

%% Estimação dos parâmetros
Modelo_estimado = pem(ze, estrutura);

%% Simulação (infinitos passos à frente)
yest = idsim(u, Modelo_estimado);

%% Comparação modelo x dados de validação
figure(1)
compare(zv, Modelo_estimado)
grid on

%% Comparação temporal
figure(2)
plot(y, 'b', 'LineWidth', 1.5)
hold on
plot(yest, 'r--', 'LineWidth', 1.5)
legend('Experimental', 'Modelo')
xlabel('Amostras')
ylabel('Pp')
grid on
