//  组合逻辑
//  通过  VGA_Controller.v      输出的"x和y坐标值" 和
//       Sdram_Control_4Port.v 输出的"Read_DATA1[15:0] 和 Read_DATA2[15:0]" ;
// -->
//  决定  输入 VGA_Controller.v      的RGB对应分量
//       输入 Sdram_Control_4Port.v 的RD2(READ2)   [RD1(READ1)由VGA_Controller.v自行输出]

module getRGB (
    //input
    input  wire        [  10:0]         X_ADDR                     ,
    input  wire        [  10:0]         Y_ADDR                     ,
    input  wire        [  15:0]         Read_DATA1                 ,
    input  wire        [  15:0]         Read_DATA2                 ,
    input  wire                         VGA_DE                     ,
    //output
    output reg         [   9:0]         VGA_iRed                   ,
    output reg         [   9:0]         VGA_iGreen                 ,
    output reg         [   9:0]         VGA_iBlue                  ,
    output wire                         Read1                      ,
    output wire                         Read2                       
);

wire                   [   9:0]         Read_DATA1_R,Read_DATA1_G,Read_DATA1_B;
wire                   [   9:0]         Read_DATA2_R,Read_DATA2_G,Read_DATA2_B;

assign Read_DATA1_R = {Read_DATA1[ 4: 0], 5'd0};
assign Read_DATA1_G = {Read_DATA1[10: 5], 4'd0};
assign Read_DATA1_B = {Read_DATA1[15:11], 5'd0};
assign Read_DATA2_R = {Read_DATA2[ 4: 0], 5'd0};
assign Read_DATA2_G = {Read_DATA2[10: 5], 4'd0};
assign Read_DATA2_B = {Read_DATA2[15:11], 5'd0};

///////////////640*480////////////////
assign Pic_1     = VGA_DE && (X_ADDR>=0    ) && (X_ADDR<320   ) && (Y_ADDR>=0) && (Y_ADDR<240  );// 划定 pic_1 的实际位置
assign Read1     = VGA_DE && (X_ADDR>=0    ) && (X_ADDR<320   ) && (Y_ADDR>=0) && (Y_ADDR<240  );
assign Pic_2     = VGA_DE && (X_ADDR>=320  ) && (X_ADDR<640   ) && (Y_ADDR>=0) && (Y_ADDR<240  );// 划定 pic_2 的实际位置
assign Read2     = VGA_DE && (X_ADDR>=320-1) && (X_ADDR<640-1 ) && (Y_ADDR>=0) && (Y_ADDR<240+9);//

always @(*) begin
    if (Pic_1) begin
        VGA_iRed   = Read_DATA1_R;
        VGA_iGreen = Read_DATA1_G;
        VGA_iBlue  = Read_DATA1_B;
    end
    else if (Pic_2) begin
        VGA_iRed   = Read_DATA2_R;
        VGA_iGreen = Read_DATA2_G;
        VGA_iBlue  = Read_DATA2_B;
    end
    else begin
        VGA_iRed   = 'd0;
        VGA_iGreen = 'd0;
        VGA_iBlue  = 'd0;
    end
end

endmodule