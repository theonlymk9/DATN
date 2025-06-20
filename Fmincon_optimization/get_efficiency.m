function result = get_efficiency(load_percent)
    % Dữ liệu gốc
    x_percent = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9];
    fuel_efficiency = [1.70, 2.50, 2.85, 3.25, 3.3, 3.4, 3.5, 3.5, 3.45];
    y = 1 ./ fuel_efficiency;
    
    % Tính hệ số hồi quy cho từng đoạn
    slopes = zeros(1, 8);
    intercepts = zeros(1, 8);
    
    for i = 1:8
        x1 = x_percent(i);
        x2 = x_percent(i+1);
        y1 = y(i);
        y2 = y(i+1);
        
        slopes(i) = (y2 - y1) / (x2 - x1);
        intercepts(i) = y1 - slopes(i) * x1;
    end
    
    % Xử lý ngoại lệ
    if load_percent < 0.0 || load_percent > 1.0
        error('Giá trị tải phải trong khoảng [0.0, 1.0]');
    end
    
    % Xác định đoạn
    if load_percent < 0.1
        segment = 1;
    elseif load_percent > 0.9
        segment = 8;
    else
        segment = find(x_percent <= load_percent, 1, 'last');
    end
    
    % Tính toán giá trị
    result = slopes(segment) * load_percent + intercepts(segment);
    
    % Xuất phương trình lần đầu tiên chạy
    persistent first_run;
    if isempty(first_run)
        first_run = true;
        fprintf('Các phương trình tuyến tính từng đoạn:\n');
        for i = 1:8
            fprintf('Đoạn %d: y = %.5fx + %.5f cho x ∈ [%.1f, %.1f]\n', ...
                    i, slopes(i), intercepts(i), x_percent(i), x_percent(i+1));
        end
        fprintf('\n');
    end
end