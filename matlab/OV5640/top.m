% 参考的 https://www.bilibili.com/video/BV16S4y1U7ZG
% https://www.bilibili.com/video/BV1c94y1Z7dV
% 我只能说'合并数据部分'并不可靠, 或者说靠流水线很难实现

clc;
clear;
close all;

init_bmp = imread('img\img30x30.bmp'); % 读取图片
sobel_img = sobel_fuc(init_bmp, 100);
[ram_conn, index_max, conn_rgb] = conn_fuc(sobel_img);
conn_rgb_line = drawLine(conn_rgb, ram_conn, index_max, [1,0,0], 1);
conn_final = drawLine(init_bmp, ram_conn, index_max, [0,255,0], 1);

subplot(2,3,1); imshow(init_bmp);      title('init_{bmp}');
subplot(2,3,2); imshow(sobel_img);     title('sobel_{bit}');
subplot(2,3,3); imshow(conn_rgb);      title('conn_{rgb}');
subplot(2,3,4); imshow(conn_rgb_line); title('conn_{rgb\_line}');
subplot(2,3,5); imshow(conn_final);    title('conn_{final}');

sobel_txt_gen(sobel_img);

% con_img_p = drawLine(con_img, ram_conn, index_max, color)
