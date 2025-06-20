clc;
clear;

run('input1.m');  % Tải dữ liệu từ file input
[c0, ceq0] = myConstraints1(x0);
disp('Initial constraints evaluated:');
disp([min(c0), max(c0)]);
disp(['Equality constraint violation (norm): ', num2str(norm(ceq0))]);

% ====== Gọi tối ưu hóa ======
options = optimoptions('fmincon','Display','iter','Algorithm','sqp');
[x_opt,fval,exitflag,output] = fmincon(@objective1, x0, [], [], [], [], [], [], @myConstraints1, options);

% ====== Tách kết quả ======
Pg1_opt = x_opt(1:24);           % Máy phát 1
Pg2_opt = x_opt(25:48);          % Máy phát 2
Pg3_opt = x_opt(49:72);          % Máy phát 3
Pg4_opt = x_opt(73:96);          % Máy phát 4
Pg5_opt = x_opt(97:120);         % Máy phát 5
P_PV_opt = x_opt(121:144);       % PV 
P_WT_opt = x_opt(145:168);       % WT
Pbess_opt = x_opt(169:192);      % BESS

% ====== Vẽ kết quả ======
figure;
plot(1:24, [Pload2, Pg1_opt, Pg2_opt, Pg3_opt, Pg4_opt, Pg5_opt], 'LineWidth', 1.5);
legend('Pload','Pg1','Pg2','Pg3','Pg4','Pg5');
title('Generators');
xlabel('Hour'); ylabel('kW'); grid on;

soc_check = soc(1:24);


figure;
plot(1:24, [Pload2, P_PV_opt, PVAvai2, P_WT_opt, WindAvai2, Pbess_opt], 'LineWidth', 1.5);
legend('Pload','P_PV_opt', 'P_PV_Avai', 'P_WT','P_Wind_Avai','Pbess');
title('Renewable Power');
xlabel('Hour'); ylabel('kW'); grid on;

figure;
plot(1:24, [soc_check], 'LineWidth', 1.5);
legend('soc');
title('SoC');
xlabel('Hour'); ylabel('kW'); grid on;

figure;
plot(1:24, [Pbess_opt], 'LineWidth', 1.5);
legend('Pbess');
title('Bess');
xlabel('Hour'); ylabel('kW'); grid on;