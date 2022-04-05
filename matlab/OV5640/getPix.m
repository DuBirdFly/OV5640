function [px1,px2,px3,px4,px5] = getPix(img, y, x)
    % @note : 参数先是y, 再是x
    % |img(y-1,x-1) | img(y-1,x) | img(y-1,x+1)|
    % |img(y  ,x-1) | img(y  ,x) |             |
    % |    px1      |    px2     |     px3     |
    % |    px4      |    px5     |
    
    px1 = round(img(y-1,x-1));
    px2 = round(img(y-1,x  ));
    px3 = round(img(y-1,x+1));
    px4 = round(img(y  ,x-1));
    px5 = round(img(y  ,x  ));
    
    end