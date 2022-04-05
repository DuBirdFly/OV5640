module sobel_filtering(
    input                               clk                        ,
    input              [   7:0]         Y_data                     ,
    input              [  10:0]         key_value                  ,
    input                               Y_de,Y_hsync,Y_vsync       ,
    output wire                         sobel_hsync,sobel_vsync,sobel_de,
    output wire                         sobel_data                  
);

//sobel ---------------------------------------------
reg                    [   9:0]         Gx1,Gx3,Gy1,Gy3,Gx,Gy      ;
reg                    [  10:0]         G                          ;
//parameter value = 11'd75;

//==========================================================================
//==    Sobel处理，耗费3clk
//==========================================================================
//clk1：Gx1、Gx3和Gy1、Gy3
//---------------------------------------------------
always @(posedge clk) begin
    Gx1 <= matrix_11 + (matrix_21 << 1) + matrix_31;
    Gx3 <= matrix_13 + (matrix_23 << 1) + matrix_33;
    Gy1 <= matrix_11 + (matrix_12 << 1) + matrix_13;
    Gy3 <= matrix_31 + (matrix_32 << 1) + matrix_33;
end

//clk2：Gx和Gy绝对值
//---------------------------------------------------
always @(posedge clk) begin
    Gx <= (Gx1 > Gx3) ? (Gx1 - Gx3) : (Gx3 - Gx1);
    Gy <= (Gy1 > Gy3) ? (Gy1 - Gy3) : (Gy3 - Gy1);
end

//clk3：Gx+Gy
//---------------------------------------------------
always @(posedge clk) begin
    G <= Gx + Gy;
end

assign sobel_data = ((G > key_value) && Y_de) ? 1'b0 : 1'b1;

//--------------------------------------------------- 矩阵顺序
//        {matrix_11, matrix_12, matrix_13}
//        {matrix_21, matrix_22, matrix_23}
//        {matrix_31, matrix_32, matrix_33}

//--------------------------------------------------- 模块例化
wire                   [   7:0]         matrix_11, matrix_12, matrix_13,matrix_21,matrix_22, matrix_23, matrix_31, matrix_32, matrix_33;

opr_3 opr_3_m0
(
    .clk                               (clk                       ),
    .din_vld                           (Y_de                      ),
    .din                               (Y_data                    ),
    .matrix_11                         (matrix_11                 ),
    .matrix_12                         (matrix_12                 ),
    .matrix_13                         (matrix_13                 ),
    .matrix_21                         (matrix_21                 ),
    .matrix_22                         (matrix_22                 ),
    .matrix_23                         (matrix_23                 ),
    .matrix_31                         (matrix_31                 ),
    .matrix_32                         (matrix_32                 ),
    .matrix_33                         (matrix_33                 ) 
);

//==========================================================================
//==    信号同步
//==========================================================================
reg                    [   3:0]         Y_de_r,Y_hsync_r,Y_vsync_r ;

always @(posedge clk) begin
    Y_de_r    <= {Y_de_r[2:0],    Y_de};
    Y_hsync_r <= {Y_hsync_r[2:0], Y_hsync};
    Y_vsync_r <= {Y_vsync_r[2:0], Y_vsync};
end

assign sobel_de    = Y_de_r[3];
assign sobel_hsync = Y_hsync_r[3];
assign sobel_vsync = Y_vsync_r[3];

endmodule