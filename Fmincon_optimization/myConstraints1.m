function [c, ceq] = myConstraints(x)
    % Tách biến
    Pg1         = x(1:24);
    Pg2         = x(25:48);
    Pg3         = x(49:72);
    Pg4         = x(73:96);
    Pg5         = x(97:120);
    PV_used     = x(121:144);
    Wind_used   = x(145:168);
    Pbess       = x(169:192);

    PRe = PV_used + Wind_used;

    % Các biến toàn cục cần load
    global Pload Pload2 PRe_avai PRe_avai2 Soc_start soc
    global Pg1_max Pg2_max Pg3_max Pg4_max Pg5_max
    global eta_ch eta_dis
    global PVAvai WindAvai
    global PVAvai2 WindAvai2

    c = [];   % ← Khởi tạo biến rỗng cho ràng buộc bất đẳng thứ 

    % Khởi tạo soc
    soc = zeros(24,1);
    soc(1) = Soc_start;

    for t = 2:25
        soc(t) = soc(t-1) - eta_ch * Pbess(t-1) / (2000);   % cập nhật BESS
    end

    % ----- Ràng buộc bất đẳng thức (c <= 0) -----
    c = [c;
        PV_used - PVAvai2;
        -PV_used;
        Wind_used - WindAvai2;
        -Wind_used;
        Pg1 - Pg1_max; 
        Pg2 - Pg2_max; 
        Pg3 - Pg3_max; 
        Pg4 - Pg4_max; 
        Pg5 - Pg5_max; 
        -Pg1;
        -Pg2;
        -Pg3;
        -Pg4;
        -Pg5;
        -soc;              % SOC >= 0
        soc - 1            % SOC <= 1
        ];
  
    % ----- Ràng buộc cân bằng công suất -----
    Pgen = Pg1 + Pg2 + Pg3 + Pg4 + Pg5;
    ceq = Pgen + PRe + Pbess - Pload2;  % Pgen + PRe + Pbess = Pload
end
