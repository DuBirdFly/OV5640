`include "video_define.v"


// 注意: iRed, iGreen, iBlue 和 oVGA_R, oVGA_G, oVGA_B 中一个iCLK(video clk)的延时
module color_bar(
    //	Host Side
    input              [   9:0]         iRed                       ,// 事实上有用的只有[9:2]
    input              [   9:0]         iGreen                     ,// 事实上有用的只有[9:2]
    input              [   9:0]         iBlue                      ,// 事实上有用的只有[9:2]
    output wire        [  11:0]         oCoord_X                   ,// = active_x;
    output wire        [  11:0]         oCoord_Y                   ,// = active_y;
    //	VGA Side
    output             [   4:0]         oVGA_R                     ,// video red data
    output             [   5:0]         oVGA_G                     ,// video green data
    output             [   4:0]         oVGA_B                     ,// video blue data
    output                              oVGA_H_SYNC                ,// horizontal synchronization
    output                              oVGA_V_SYNC                ,// vertical synchronization
    output                              oVGA_SYNC                  ,// useless,always 1'b0
    output                              oVGA_BLANK                 ,// useless,assign oVGA_BLANK = oVGA_H_SYNC & oVGA_V_SYNC;
    output                              oVGA_CLOCK                 ,// uesless,assign oVGA_CLOCK =	iCLK;
    output                              oVGA_DE                    ,// video valid，video_active = h_active & v_active
    //	Control Signal
    input                               iCLK                       ,// pixel clock
    input                               rst                         // reset signal high active, rst == ~rst_n
);

/**
更多参数见
blog.csdn.net/xl19862005/article/details/9024339
------------------------------------
极性：有正极性和负极性（HS_POL，VS_POL）
正极性：低电平时间长，高电平时间短（短凸起）
负极性：高电平时间长，低电平时间短（短凹陷)
------------------------------------
lite版color_bar.v见
F:\Document\ZPF_Document\ZPF_FPGA\MyCore\09_VGA\11_VGA\rtl\myCore\VGA
*/

//30x30 1Mhz 超迷你VGA 仅供仿真使用
`ifdef  VIDEO_30x30
    parameter                           H_ACTIVE = 16'd30          ;
    parameter                           H_FP = 16'd2               ;
    parameter                           H_SYNC = 16'd5             ;
    parameter                           H_BP = 16'd2               ;
    parameter                           V_ACTIVE = 16'd30          ;
    parameter                           V_FP = 16'd2               ;
    parameter                           V_SYNC = 16'd5             ;
    parameter                           V_BP = 16'd2               ;
    parameter                           HS_POL = 1'b0              ;
    parameter                           VS_POL = 1'b0              ;
`endif

//480x272 9Mhz
`ifdef  VIDEO_480_272
    parameter                           H_ACTIVE = 16'd480         ;
    parameter                           H_FP = 16'd2               ;
    parameter                           H_SYNC = 16'd41            ;
    parameter                           H_BP = 16'd2               ;
    parameter                           V_ACTIVE = 16'd272         ;
    parameter                           V_FP = 16'd2               ;
    parameter                           V_SYNC = 16'd10            ;
    parameter                           V_BP = 16'd2               ;
    parameter                           HS_POL = 1'b0              ;
    parameter                           VS_POL = 1'b0              ;
`endif

//640x480 25.175Mhz
`ifdef  VIDEO_640_480
    parameter                           H_ACTIVE = 16'd640         ;
    parameter                           H_FP = 16'd16              ;
    parameter                           H_SYNC = 16'd96            ;
    parameter                           H_BP = 16'd48              ;
    parameter                           V_ACTIVE = 16'd480         ;
    parameter                           V_FP = 16'd10              ;
    parameter                           V_SYNC = 16'd2             ;
    parameter                           V_BP = 16'd33              ;
    parameter                           HS_POL = 1'b0              ;
    parameter                           VS_POL = 1'b0              ;
`endif

//800x480 33Mhz
`ifdef  VIDEO_800_480
    parameter                           H_ACTIVE = 16'd800         ;
    parameter                           H_FP = 16'd40              ;
    parameter                           H_SYNC = 16'd128           ;
    parameter                           H_BP = 16'd88              ;
    parameter                           V_ACTIVE = 16'd480         ;
    parameter                           V_FP = 16'd1               ;
    parameter                           V_SYNC = 16'd3             ;
    parameter                           V_BP = 16'd21              ;
    parameter                           HS_POL = 1'b0              ;
    parameter                           VS_POL = 1'b0              ;
`endif

//800x600 40Mhz
`ifdef  VIDEO_800_600
    parameter                           H_ACTIVE = 16'd800         ;
    parameter                           H_FP = 16'd40              ;
    parameter                           H_SYNC = 16'd128           ;
    parameter                           H_BP = 16'd88              ;
    parameter                           V_ACTIVE = 16'd600         ;
    parameter                           V_FP = 16'd1               ;
    parameter                           V_SYNC = 16'd4             ;
    parameter                           V_BP = 16'd23              ;
    parameter                           HS_POL = 1'b1              ;
    parameter                           VS_POL = 1'b1              ;
`endif

//1024x768 65Mhz
`ifdef  VIDEO_1024_768
    parameter                           H_ACTIVE = 16'd1024        ;
    parameter                           H_FP = 16'd24              ;
    parameter                           H_SYNC = 16'd136           ;
    parameter                           H_BP = 16'd160             ;
    parameter                           V_ACTIVE = 16'd768         ;
    parameter                           V_FP = 16'd3               ;
    parameter                           V_SYNC = 16'd6             ;
    parameter                           V_BP = 16'd29              ;
    parameter                           HS_POL = 1'b0              ;
    parameter                           VS_POL = 1'b0              ;
`endif

//video timing parameter definition   74.25MHz
`ifdef  VIDEO_1280_720_POS
    parameter                           H_ACTIVE = 16'd1280        ;// horizontal active time (pixels)
    parameter                           H_FP = 16'd110             ;// horizontal front porch (pixels)
    parameter                           H_SYNC = 16'd40            ;// horizontal sync time(pixels)
    parameter                           H_BP = 16'd220             ;// horizontal back porch (pixels)
    parameter                           V_ACTIVE = 16'd720         ;// vertical active Time (lines)
    parameter                           V_FP = 16'd5               ;// vertical front porch (lines)
    parameter                           V_SYNC = 16'd5             ;// vertical sync time (lines)
    parameter                           V_BP = 16'd20              ;// vertical back porch (lines)
    parameter                           HS_POL = 1'b1              ;// horizontal sync polarity, 1 : POSITIVE,0 : NEGATIVE;
    parameter                           VS_POL = 1'b1              ;// vertical sync polarity, 1 : POSITIVE,0 : NEGATIVE;
`endif

//video timing parameter definition   74.25MHz
`ifdef  VIDEO_1280_720_NEG
    parameter                           H_ACTIVE = 16'd1280        ;// horizontal active time (pixels)
    parameter                           H_FP = 16'd110             ;// horizontal front porch (pixels)
    parameter                           H_SYNC = 16'd40            ;// horizontal sync time(pixels)
    parameter                           H_BP = 16'd220             ;// horizontal back porch (pixels)
    parameter                           V_ACTIVE = 16'd720         ;// vertical active Time (lines)
    parameter                           V_FP = 16'd5               ;// vertical front porch (lines)
    parameter                           V_SYNC = 16'd5             ;// vertical sync time (lines)
    parameter                           V_BP = 16'd20              ;// vertical back porch (lines)
    parameter                           HS_POL = 1'b0              ;// horizontal sync polarity, 1 : POSITIVE,0 : NEGATIVE;
    parameter                           VS_POL = 1'b0              ;// vertical sync polarity, 1 : POSITIVE,0 : NEGATIVE;
`endif

//1920x1080 148.5Mhz
`ifdef  VIDEO_1920_1080
    parameter                           H_ACTIVE = 16'd1920        ;
    parameter                           H_FP = 16'd88              ;
    parameter                           H_SYNC = 16'd44            ;
    parameter                           H_BP = 16'd148             ;
    parameter                           V_ACTIVE = 16'd1080        ;
    parameter                           V_FP = 16'd4               ;
    parameter                           V_SYNC = 16'd5             ;
    parameter                           V_BP = 16'd36              ;
    parameter                           HS_POL = 1'b1              ;
    parameter                           VS_POL = 1'b1              ;
`endif


    parameter                           H_TOTAL = H_ACTIVE + H_FP + H_SYNC + H_BP;// horizontal total time (pixels)
    parameter                           V_TOTAL = V_ACTIVE + V_FP + V_SYNC + V_BP;// vertical total time (lines)
    parameter                           H_PASSIVE = H_FP + H_SYNC + H_BP;
    parameter                           V_PASSIVE = V_FP + V_SYNC + V_BP;

//------------------------------------------------------------------
reg                                     hs_reg                     ;// horizontal sync register
reg                                     vs_reg                     ;// vertical sync register
reg                                     hs_reg_d0                  ;// delay 1 clock of 'hs_reg'
reg                                     vs_reg_d0                  ;// delay 1 clock of 'vs_reg'
reg                    [  11:0]         h_cnt                      ;// horizontal counter
reg                    [  11:0]         v_cnt                      ;// vertical counter
reg                    [  11:0]         active_x                   ;// video x position 
reg                    [  11:0]         active_y                   ;// video y position 
reg                    [   4:0]         rgb_r_reg                  ;// video red data register
reg                    [   5:0]         rgb_g_reg                  ;// video green data register
reg                    [   4:0]         rgb_b_reg                  ;// video blue data register
reg                                     h_active                   ;// horizontal video active
reg                                     v_active                   ;// vertical video active
wire                                    video_active               ;// video active(horizontal active and vertical active)

//------------------------------------------------------------------
assign oVGA_H_SYNC = hs_reg_d0;
assign oVGA_V_SYNC = vs_reg_d0;
assign video_active = h_active & v_active;
assign oVGA_DE = video_active;
assign oVGA_R = rgb_r_reg;
assign oVGA_G = rgb_g_reg;
assign oVGA_B = rgb_b_reg;
assign oCoord_X = active_x;
assign oCoord_Y = active_y;

//------------------------------------------------------------------
assign oVGA_SYNC = 1'b0;
assign oVGA_BLANK = oVGA_H_SYNC & oVGA_V_SYNC;
assign oVGA_CLOCK =    iCLK;

//------------------------------------------------------------------
always@(posedge iCLK or posedge rst) begin
    if(rst == 1'b1) begin
        hs_reg_d0 <= 1'b0;
        vs_reg_d0 <= 1'b0;
    end
    else begin
        hs_reg_d0 <= hs_reg;
        vs_reg_d0 <= vs_reg;
    end
end

//------------------------------------------------------------------
// h_cnt
always@(posedge iCLK or posedge rst) begin
    if(rst == 1'b1)
        h_cnt <= 12'd0;
    else if(h_cnt == H_TOTAL - 1)                                   // horizontal counter maximum value
        h_cnt <= 12'd0;
    else
        h_cnt <= h_cnt + 12'd1;
end

// v_cnt
always@(posedge iCLK or posedge rst) begin
    if(rst == 1'b1)
        v_cnt <= 12'd0;
    else if(h_cnt == H_FP  - 1)                                     // horizontal sync time
        if(v_cnt == V_TOTAL - 1)                                    // vertical counter maximum value
            v_cnt <= 12'd0;
        else
            v_cnt <= v_cnt + 12'd1;
    else
        v_cnt <= v_cnt;
end

// 下面的这一种计算方法是可能会导致"组合逻辑链"过长, 不建议使用
// 尤其是 v_cnt >= V_PASSIVE - 1'b1 的时序判断赋值直接变成了组合判断赋值, 可以用仿真一下看看aaa的变化
// active_x
// always@(posedge iCLK or posedge rst) begin
//     if(rst == 1'b1)
//         active_x <= 12'd0;
//     else if(h_cnt >= H_PASSIVE - 1'b1)
//         active_x <= h_cnt - H_PASSIVE + 1'b1;
//     else 
//         active_x <= active_x;
// end

// active_y
// reg aaa;
// always@(posedge iCLK or posedge rst) begin
//     if(rst == 1'b1) 
//         active_y <= 12'd0;
//     else if(v_cnt >= V_PASSIVE - 1'b1)begin
//         active_y <= v_cnt - V_PASSIVE + 1'b1;
//         aaa <= 1'b1;
//     end
//     else begin
//         active_y <= active_y;
//         aaa <= 1'b0;
//     end
// end


// active_x
always@(posedge iCLK or posedge rst) begin
    if(rst == 1'b1)
        active_x <= 12'd0;
    else if (h_cnt == H_PASSIVE - 1'b1)
        active_x <= 1'b0;
    else if (h_cnt >= H_PASSIVE)
        active_x <= active_x + 1'b1;
    else 
        active_x <= active_x;
end

// active_y
always@(posedge iCLK or posedge rst) begin
    if(rst == 1'b1) 
        active_y <= 12'd0;
    else if (h_cnt == H_FP - 1) begin           //加一层对h_cnt判断是为了避免频繁赋值/自加
        if (v_cnt == V_PASSIVE - 1'b1)
            active_y <= 1'b0;
        else if (v_cnt >= V_PASSIVE)
            active_y <= active_y + 1'b1;
        else
            active_y <= active_y;
    end
    else 
        active_y <= active_y;
end

// hs_reg
always@(posedge iCLK or posedge rst) begin
    if(rst == 1'b1)
        hs_reg <= 1'b0;
    else if(h_cnt == H_FP - 1)                                      // horizontal sync begin
        hs_reg <= HS_POL;
    else if(h_cnt == H_FP + H_SYNC - 1)                             // horizontal sync end
        hs_reg <= ~hs_reg;
    else
        hs_reg <= hs_reg;
end

// vs_reg
always@(posedge iCLK or posedge rst) begin
    if(rst == 1'b1)
        vs_reg <= 1'd0;
    else if((v_cnt == V_FP - 1) && (h_cnt == H_FP - 1))             // vertical sync begin
        vs_reg <= HS_POL;
    else if((v_cnt == V_FP + V_SYNC - 1) && (h_cnt == H_FP - 1))    // vertical sync end
        vs_reg <= ~vs_reg;
    else
        vs_reg <= vs_reg;
end

// h_active
always@(posedge iCLK or posedge rst) begin
    if(rst == 1'b1)
        h_active <= 1'b0;
    else if(h_cnt == H_FP + H_SYNC + H_BP - 1)                      // horizontal active begin
        h_active <= 1'b1;
    else if(h_cnt == H_TOTAL - 1)                                   // horizontal active end
        h_active <= 1'b0;
    else
        h_active <= h_active;
end

// v_active
always@(posedge iCLK or posedge rst) begin
    if(rst == 1'b1)
        v_active <= 1'd0;
    else if((v_cnt == V_FP + V_SYNC + V_BP - 1) && (h_cnt == H_FP - 1))  // vertical active begin
        v_active <= 1'b1;
    else if((v_cnt == V_TOTAL - 1) && (h_cnt == H_FP - 1))               // vertical active end
        v_active <= 1'b0;
    else
        v_active <= v_active;
end

//------------------------------------------------------------------
always@(posedge iCLK or posedge rst) begin
    if(rst == 1'b1) begin
        rgb_r_reg <= 1'd0;
        rgb_g_reg <= 1'd0;
        rgb_b_reg <= 1'd0;
    end
    else if(video_active) begin
        rgb_r_reg <= iRed  [9:5];
        rgb_g_reg <= iGreen[9:4];
        rgb_b_reg <= iBlue [9:5];
    end
    else begin
        rgb_r_reg <= 1'd0;
        rgb_g_reg <= 1'd0;
        rgb_b_reg <= 1'd0;
    end
end

endmodule