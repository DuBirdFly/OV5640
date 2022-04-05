function sobel_img = sobel_fuc(img, value)
% @brief    对输入的图像做sobel处理
% @note     None
% @param    img: 输入图像矩阵
% @param    value : sobel阈值, 一般建议为100
% @retval   sobel_img : sobel处理后的图像矩阵

gray = double(rgb2gray(img));       % 灰度图
[ROW,COL] = size(gray);             % 得到图像行列数
sobel_img = zeros(ROW,COL);

for r = 2:ROW-1
    for c = 2:COL-1
        Gx = gray(r-1,c+1) + 2*gray(r,c+1) + gray(r+1,c+1) - gray(r-1,c-1) - 2*gray(r,c-1) - gray(r+1,c-1);
        Gy = gray(r-1,c-1) + 2*gray(r-1,c) + gray(r-1,c+1) - gray(r+1,c-1) - 2*gray(r+1,c) - gray(r+1,c+1);
        G = abs(Gx) + abs(Gy); %G = sqrt(Gx^2 + Gy^2);
        if(G > value)
            sobel_img(r,c)=1;
        else
            sobel_img(r,c)=0;
        end
    end
end


end

