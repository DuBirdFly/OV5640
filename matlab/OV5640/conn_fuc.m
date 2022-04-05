function [ram_conn, index_max, conn_rgb] = conn_fuc(sobel_img)
% conn_rgb 是连通域处理的中间参考图像, 可以不返回这两个图像矩阵

ram_conn = zeros(5,256);        % 4行256列, 1-4行分别对应'Xmin, Ymin, Xmax, Ymax, flag'

[ROW, COL] = size(sobel_img);         % 得到图像行列数

index_max = 0;
for y = 2:ROW - 1               
    for x = 2:COL - 1           
        [px1,px2,px3,px4,px5] = getPix(sobel_img, y, x);
        if px5 == 1             % '中'有值
            if px4 ~= 0         % '左'有值
                sobel_img(y,x) = px4;
                if px3 == 0             % '右上'为0
                    ram_conn(1:4,px4) = combine_data(x, y, ram_conn, px4)';
                elseif px3 ~= px4       % '右上'有不同于'左'的不为0值, 说明当前标记的ram_max的值不是真实的, 需要参数合并
                    ram_conn(1:4,px4) = combine_data(x, y, ram_conn, px3);  % 把'右上'数据合并到当前点
                    ram_conn(5,px3) = px4;                                  % '右上'连通域标记无效并指向'当前'的索引
                else                    % '右上'值与'左'的值相同且不为0值
                    ram_conn(1:4,px3) = combine_data(x, y, ram_conn, px3);
                end
            elseif px1 ~= 0     % '左'无值, '左上'有值
                targetIndex = ram_conn(5,px1);
                if targetIndex == 0     % '左上'是有效连通域
                    sobel_img(y,x) = px1;
                    ram_conn(1:4,px1) = combine_data(x, y, ram_conn, px1);
                else                        % '左上'是无效连通域
                    while ram_conn(5,targetIndex) ~= 0
                        targetIndex = ram_conn(5,targetIndex);
                    end
                    sobel_img(y,x) = targetIndex;
                    ram_conn(1:4,px1) = combine_data(x, y, ram_conn, targetIndex);
                end
            elseif px2 ~= 0     % '左'无值, '左上'无值, '上'有值
                sobel_img(y,x) = px2;
                ram_conn(1:4,px2) = combine_data(x, y, ram_conn, px2);
            elseif px3 ~= 0     % '左'无值, '上'无值, '左上'无值, '右上'有值
                sobel_img(y,x) = px3;
                ram_conn(1:4,px3) = combine_data(x, y, ram_conn, px3);
            else                % '左'无值, '上'无值, '左上'无值, '右上'无值, 只有'中间'有值
                index_max = index_max + 1;
                sobel_img(y,x) = index_max;
                ram_conn(:,index_max) = [x,y,x,y,0];    % 注: 0为'有效'的意思
            end
        end
    end
end


conn_rgb = drawRGB(sobel_img);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 以下部分是简化 ram_conn 的空间(只记录 flag == 0 的值), 实际Verilog代码可以忽视 %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 找到实际有效的连通域个数
conn_num = 0;                       % 实际有效的连通域个数
for i = 1:index_max
    if ram_conn(5,i) == 0
        conn_num = conn_num + 1;
    end
end
% 实际有效的连通域ram空间初始化
ram_conn_temp = zeros(4,conn_num);  
% 实际写入有效的连通域ram空间
index_max_temp = 0;
for i = 1:index_max
    if ram_conn(5,i) == 0
        index_max_temp = index_max_temp + 1;
        ram_conn_temp(1:4,index_max_temp) = ram_conn(1:4,i);
    end
end
% 将两个实际有效的矩阵完全覆盖原矩阵
ram_conn = ram_conn_temp;
index_max = index_max_temp;

end