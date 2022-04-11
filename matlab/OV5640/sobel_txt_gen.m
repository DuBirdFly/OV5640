function [] = sobel_txt_gen(img)

[ROW,COL] = size(img);

fid = fopen('img\img.txt','w+');                       %打开或新建一个txt文件

for r = 1:ROW
    for c = 1 : COL
        fprintf(fid,'%01x ',img(r,c));                   %写入图片数据
    end
end

fclose(fid);

end