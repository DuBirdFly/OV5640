function con_img = drawRGB(sobel_img)

% matlab的RGB是[0,1]区间的, 你可以用rescale(A)进行RGB归一化, 或者手动输入
% https://blog.csdn.net/ha_____ha/article/details/103683988

[ROW, COL] = size(sobel_img);         % 得到图像行列数

con_img = zeros(ROW,COL,3);
for y = 1:ROW           % [1~100]
    for x = 1:COL       % [1~100]
        if sobel_img(y,x) == 0
            con_img(y,x,:) = [0,0,0];
        else
            temp = mod(sobel_img(y,x), 6);
            switch temp
            case 1
                con_img(y,x,:) = [1.00,1.00,1.00];
            case 2
                con_img(y,x,:) = [0.00,1.00,0.00];
            case 3
                con_img(y,x,:) = [0.00,0.00,1.00];
            case 4
                con_img(y,x,:) = [1.00,1.00,0.00];
            case 5
                con_img(y,x,:) = [1.00,0.00,1.00];
            case 0
                con_img(y,x,:) = [0.00,1.00,1.00];
            end
        end
    end
end

end

