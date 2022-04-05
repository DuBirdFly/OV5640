function con_img_p = drawLine(con_img, ram_conn, index_max, color, param)
% color是归一化的RGB矩阵, 如[1.00,0.85,0.37]
% param = 0 时表示 ram_conn 和 index_max 未在 conn_fuc()函数 进行简化处理; param = 1则反之

con_img_p = con_img;

if param == 0
    for i = 1:index_max
        if ram_conn(5,i) == 0
            Xmin = ram_conn(1,i);
            Ymin = ram_conn(2,i);
            Xmax = ram_conn(3,i);
            Ymax = ram_conn(4,i);
            for x = Xmin:Xmax
                con_img_p(Ymin,x,:) = color;
                con_img_p(Ymax,x,:) = color;
            end
            for y = Ymin:Ymax
                con_img_p(y,Xmin,:) = color;
                con_img_p(y,Xmax,:) = color;
            end
        end
    end
end

if param == 1
    for i = 1:index_max
        Xmin = ram_conn(1,i);
        Ymin = ram_conn(2,i);
        Xmax = ram_conn(3,i);
        Ymax = ram_conn(4,i);
        for x = Xmin:Xmax
            con_img_p(Ymin,x,:) = color;
            con_img_p(Ymax,x,:) = color;
        end
        for y = Ymin:Ymax
            con_img_p(y,Xmin,:) = color;
            con_img_p(y,Xmax,:) = color;
        end
    end
end

end