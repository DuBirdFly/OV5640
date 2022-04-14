module YCbCr(
    input                               clk                        ,
    input                               RGB_de,RGB_hsync,RGB_vsync ,
    input              [  15:0]         RGB_data                   ,//  RGB565格式
    output                              gray_de,gray_hsync,gray_vsync,
    output             [   7:0]         gray_data                   
);

wire                   [   7:0]         R0,G0,B0                   ;
reg                    [  15:0]         R1,G1,B1,R2,G2,B2,R3,G3,B3 ;
reg                    [  15:0]         Y1,Cb1,Cr1                 ;
reg                    [   7:0]         Y2,Cb2,Cr2                 ;

reg                    [   2:0]         RGB_de_r,RGB_hsync_r,RGB_vsync_r;

assign R0 = {RGB_data[15:11],RGB_data[13:11]};                      //  R8
assign G0 = {RGB_data[10: 5],RGB_data[ 6: 5]};                      //  G8
assign B0 = {RGB_data[ 4: 0],RGB_data[ 2: 0]};                      //  B8
// assign gray_data = {Y2[7:3],Y2[7:2],Y2[7:3]}; //只取Y分量给RGB565格式
assign gray_data = Y2;

always @(posedge clk) begin
    {R1,G1,B1} <= { {R0 * 16'd77},  {G0 * 16'd150}, {B0 * 16'd29 } };
    {R2,G2,B2} <= { {R0 * 16'd43},  {G0 * 16'd85},  {B0 * 16'd128} };
    {R3,G3,B3} <= { {R0 * 16'd128}, {G0 * 16'd107}, {B0 * 16'd21 } };
end

always @(posedge clk) begin
    Y1  <= R1 + G1 + B1;
    Cb1 <= B2 - R2 - G2 + 16'd32768;                                //  128扩大256倍
    Cr1 <= R3 - G3 - B3 + 16'd32768;                                //  128扩大256倍
end

always @(posedge clk) begin
    Y2  <= Y1[15:8];
    Cb2 <= Cb1[15:8];
    Cr2 <= Cr1[15:8];
end
//==========================================================================
//==    信号同步(打三拍)
//==========================================================================
always @(posedge clk) begin
    RGB_de_r    <= {RGB_de_r[1:0],    RGB_de};
    RGB_hsync_r <= {RGB_hsync_r[1:0], RGB_hsync};
    RGB_vsync_r <= {RGB_vsync_r[1:0], RGB_vsync};
end

assign gray_de    = RGB_de_r[2];
assign gray_hsync = RGB_hsync_r[2];
assign gray_vsync = RGB_vsync_r[2];


endmodule