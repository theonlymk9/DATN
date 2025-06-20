function J = objective(x)
    % Dùng biến toàn cục
    global PRe_avai PRe_avai2
    global total_fuel_max

    % ====== Tách biến ======
    Pg1         = x(1:24);
    Pg2         = x(25:48);
    Pg3         = x(49:72);
    Pg4         = x(73:96);
    Pg5         = x(97:120);
    PV_used     = x(121:144);
    Wind_used   = x(145:168);
    PBess       = x(169:192);      % Thêm 24 biến

    PRe = PV_used + Wind_used;


    % ====== Định nghĩa giá nhiên liệu hoặc hiệu suất từng máy ======
    % Giả sử đơn vị: đơn vị nhiên liệu/kWh

    max_capacity = [560, 630, 410, 1000, 1000]; % kW cho máy 1-5

    Pg_matrix = [Pg1(:), Pg2(:), Pg3(:), Pg4(:), Pg5(:)];
    load_percent = Pg_matrix ./ max_capacity;
    fuel_coeff = arrayfun(@get_efficiency, load_percent);
    hourly_fuel = sum(fuel_coeff .* Pg_matrix, 2);


    J_gen_normalize = hourly_fuel/total_fuel_max;

    % ====== Phạt nếu không dùng hết năng lượng tái tạo ======
    PRe_waste = PRe_avai2 - PRe;

    PRE_waste_normalize = PRe_waste/PRe_avai2;

    J_Re_waste = sum(PRE_waste_normalize);

    % ====== Hàm mục tiêu tổng ======
    J = (J_Re_waste + J_gen_normalize) ;
end
