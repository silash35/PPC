close all
clear
clc

%% Leitura dos dados
dados = readtable('../data/simulation_deviation.csv');   % nome do arquivo CSV

t     = dados.t;
m_dot = dados.m_dot;
Pp    = dados.Pp;
N     = dados.N;
alpha = dados.alpha;

y = [m_dot Pp];
u = [N alpha]; % entradas multiplas

%% Configurações
Ts = 0.1;   % intervalo de amostragem estimado a partir do tempo
N_est = floor(length(t)*0.5); % Separação em dados de estimação e validação

%% Criando modelo MIMO
z_train = iddata(y(1:N_est,:), u(1:N_est,:), Ts);
z_validation = iddata(y(N_est+1:end,:), u(N_est+1:end,:), Ts);

modelo = procest(z_train, {'P2ZU', 'P2ZU'; 'P2ZU', 'P2ZU'});
tf(modelo(1,1))
tf(modelo(1,2))
tf(modelo(2,1))
tf(modelo(2,2))

compare(z_validation, modelo)
