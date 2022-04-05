function combine = combine_data(x, y, ram_conn, adder)
% ram_conn = zeros(4,256);        % 4行256列, 1-4行分别对应'Xmin, Ymin, Xmax, Ymax'
% 当前点的数据为(x,y), 参考的数据为 ram_conn(1:4,addr)

    ram_Xmin = ram_conn(1,adder);
    ram_Ymin = ram_conn(2,adder);
    ram_Xmax = ram_conn(3,adder);
    ram_Ymax = ram_conn(4,adder);

    if x < ram_Xmin
        Xmin = x;
    else
        Xmin = ram_Xmin;
    end

    if y < ram_Ymin
        Ymin = y;
    else
        Ymin = ram_Ymin;
    end

    if x > ram_Xmax
        Xmax = x;
    else
        Xmax = ram_Xmax;
    end    
    
    if y > ram_Ymax
        Ymax = y;
    else
        Ymax = ram_Ymax;
    end

    combine(1) = Xmin;
    combine(2) = Ymin;
    combine(3) = Xmax;
    combine(4) = Ymax;

end