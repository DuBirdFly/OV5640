module opr_3(
    input                               din_vld                    ,
    input                               clk                        ,
    input              [   7:0]         din                        ,
    output reg         [   7:0]         matrix_11, matrix_12, matrix_13,matrix_21,matrix_22, matrix_23, matrix_31, matrix_32, matrix_33 
);

//矩阵数据选取
//---------------------------------------------------
wire                   [   7:0]         row_1,row_2,row_3          ;
wire                   [   7:0]         taps0x,taps1x              ;

assign row_1 = taps1x;
assign row_2 = taps0x;
assign row_3 = din;
//assign matrix ={matrix_33, matrix_32, matrix_31,matrix_23, matrix_22, matrix_21,matrix_13, matrix_12, matrix_11};

//打拍形成矩阵，矩阵顺序归正
//---------------------------------------------------
always @(posedge clk) begin
    {matrix_11, matrix_12, matrix_13} <= {matrix_12, matrix_13, row_1};
    {matrix_21, matrix_22, matrix_23} <= {matrix_22, matrix_23, row_2};
    {matrix_31, matrix_32, matrix_33} <= {matrix_32, matrix_33, row_3};
end

shift_ip_3 shift_ip_3_m0
(
    .clken                             (din_vld                   ),
    .clock                             (clk                       ),
    .shiftin                           (din                       ),
    .shiftout                          (                          ),
    .taps0x                            (taps0x                    ),
    .taps1x                            (taps1x                    ) 
);

endmodule