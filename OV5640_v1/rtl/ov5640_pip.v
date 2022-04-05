// --------------------------------------------------------------------
// Copyright (c) 2005 by Alinx Technologies Inc. 
// --------------------------------------------------------------------
// --------------------------------------------------------------------

module ov5640_pip(
////////////////////////	SYS Input	 	////////////////////////
    input  wire                         CLOCK_50                   ,//	50 MHz
    input  wire                         RST_N                      ,
///////////////////////		SDRAM Interface	////////////////////////
    inout              [  15:0]         DRAM_DQ                    ,//	SDRAM Data bus 16 Bits
    output wire        [  11:0]         DRAM_ADDR                  ,//	SDRAM Address bus 12 Bits
    output wire                         DRAM_LDQM                  ,//	SDRAM Low-byte Data Mask 
    output wire                         DRAM_UDQM                  ,//	SDRAM High-byte Data Mask
    output wire                         DRAM_WE_N                  ,//	SDRAM Write Enable
    output wire                         DRAM_CAS_N                 ,//	SDRAM Column Address Strobe
    output wire                         DRAM_RAS_N                 ,//	SDRAM Row Address Strobe
    output wire                         DRAM_CS_N                  ,//	SDRAM Chip Select
    output wire                         DRAM_BA_0                  ,//	SDRAM Bank Address 0
    output wire                         DRAM_BA_1                  ,//	SDRAM Bank Address 0
    output wire                         DRAM_CLK                   ,//	SDRAM Clock
    output wire                         DRAM_CKE                   ,//	SDRAM Clock Enable
////////////////////////	VGA			////////////////////////////
    output wire                         VGA_HS                     ,//	VGA H_SYNC
    output wire                         VGA_VS                     ,//	VGA V_SYNC
    output wire        [   4:0]         VGA_R                      ,//	VGA Red[9:0]
    output wire        [   5:0]         VGA_G                      ,//	VGA Green[9:0]
    output wire        [   4:0]         VGA_B                      ,//	VGA Blue[9:0]
////////////////////////	CMOS1			////////////////////////////
    output wire                         CMOS1_SCL                  ,//  CMOS1 i2c clock
    inout  wire                         CMOS1_SDA                  ,//  CMOS1 i2c data
    input  wire                         CMOS1_VSYNC                ,//  CMOS1 vsync
    input  wire                         CMOS1_HREF                 ,//  CMOS1 hsync refrence
    input  wire                         CMOS1_PCLK                 ,//  CMOS1 pxiel clock
    input  wire        [   7:0]         CMOS1_D                    ,//  CMOS1 data
    output wire                         CMOS1_RESET                ,//  CMOS1 reset
////////////////////////	CMOS2			////////////////////////////
    output wire                         CMOS2_SCL                  ,//  CMOS2 i2c clock
    inout  wire                         CMOS2_SDA                  ,//  CMOS2 i2c data
    input  wire                         CMOS2_VSYNC                ,//  CMOS2 vsync
    input  wire                         CMOS2_HREF                 ,//  CMOS2 hsync refrence
    input  wire                         CMOS2_PCLK                 ,//  CMOS2 pxiel clock
    input  wire        [   7:0]         CMOS2_D                    ,//  CMOS2 data
    output wire                         CMOS2_RESET                ,//  CMOS2 reset
////////////////////////   other hardwares  ///////////////////////
    input  wire                         iKEY                       ,
    output wire        [   7:0]         DIG                        ,//DP,G,……,A
    output wire        [   5:0]         SEL                         
);

wire                   [  15:0]         Read_DATA1                 ;
wire                   [  15:0]         Read_DATA2                 ;
wire                                    VGA_CTRL_CLK               ;

wire                                    Read1                      ;
wire                                    Read2                      ;

wire                   [  10:0]         X_ADDR                     ;
wire                   [  10:0]         Y_ADDR                     ;

wire                   [   9:0]         VGA_iRed                   ;
wire                   [   9:0]         VGA_iGreen                 ;
wire                   [   9:0]         VGA_iBlue                  ;

wire                                    color_bar_de,color_bar_hs,color_bar_vs;
wire                   [  15:0]         color_bar_rgb              ;

wire                                    sobel_hs, sobel_vs, sobel_de;
wire                   [  15:0]         sobel_data                 ;

wire                   [  10:0]         key_value                  ;

//-----------------------------------------------------------------
getRGB inst_getRGB (
    //input
    .X_ADDR                            (X_ADDR                    ),
    .Y_ADDR                            (Y_ADDR                    ),
    .Read_DATA1                        (Read_DATA1                ),
    .Read_DATA2                        (Read_DATA2                ),
    .VGA_DE                            (color_bar_de              ),
    //output
    .VGA_iRed                          (VGA_iRed                  ),
    .VGA_iGreen                        (VGA_iGreen                ),
    .VGA_iBlue                         (VGA_iBlue                 ),
    .Read1                             (Read1                     ),
    .Read2                             (Read2                     ) 
);

//-----------------------------------------------------------------
wire                                    initial_en                 ;
wire                                    DLY_RST_0                  ;
Reset_Delay u_Reset_Delay (
    .iCLK                              (CLOCK_50                  ),
    .iRST                              (RST_N                     ),
    .oRST_0                            (DLY_RST_0                 ),
    .oRST_1                            (CMOS1_RESET               ),
    .oRST_2                            (CMOS2_RESET               ),
    .oRST_3                            (initial_en                ) 
);

//-----------------------------------------------------------------
wire                                    Clk_camera                 ;
clock_pll u_clok_pll (
    .inclk0                            (CLOCK_50                  ),//50MHz
    .areset                            (~RST_N                    ),
    .locked                            (                          ),
    .c0                                (VGA_CTRL_CLK              ),//VGA CLK
    .c1                                (Clk_camera                ) //CMOS 24MHz
);

//-----------------------------------------------------------------
//CMOS1 Camera初始化部分
wire                                    Cmos1_Config_Done          ;
cmos2_reg_config cmos_config_1(
    .clk_25M                           (Clk_camera                ),
    .camera_rstn                       (CMOS1_RESET               ),
    .initial_en                        (initial_en                ),
    .i2c_sclk                          (CMOS1_SCL                 ),
    .i2c_sdat                          (CMOS1_SDA                 ),
    .reg_conf_done                     (Cmos1_Config_Done         ),
    .reg_index                         (                          ),
    .clock_20k                         (                          ) 
);

//-----------------------------------------------------------------
//CMOS2 Camera初始化部分
wire                                    Cmos2_Config_Done          ;
cmos2_reg_config cmos_config_2 (
    .clk_25M                           (Clk_camera                ),
    .camera_rstn                       (CMOS2_RESET               ),
    .initial_en                        (initial_en                ),
    .i2c_sclk                          (CMOS2_SCL                 ),
    .i2c_sdat                          (CMOS2_SDA                 ),
    .reg_conf_done                     (Cmos2_Config_Done         ),
    .reg_index                         (                          ),
    .clock_20k                         (                          ) 
);

//-----------------------------------------------------------------
wire                                    CMOS1_WE                   ;//data write enable
wire                   [  15:0]         CMOS1_DATA_16              ;//cmos RGB 16bits 
CMOS_Capture u1_CMOS_Capture(
	//Global Clock
    .iCLK                              (Clk_camera                ),//24MHz
    .iRST_N                            (DLY_RST_0                 ),//global reset
	//I2C Initilize Done
    .Init_Done                         (Cmos1_Config_Done         ),//Init Done
	//Sensor Interface
    .CMOS_XCLK                         (                          ),//cmos
    .CMOS_PCLK                         (CMOS1_PCLK                ),//24MHz
    .CMOS_iDATA                        (CMOS1_D                   ),//CMOS Data
    .CMOS_VSYNC                        (CMOS1_VSYNC               ),//L: Vaild
    .CMOS_HREF                         (CMOS1_HREF                ),//H: Vaild
	//Ouput Sensor Data
    .CMOS_oCLK                         (CMOS1_WE                  ),//Data PCLK
    .CMOS_oDATA                        (CMOS1_DATA_16             ),//16Bits RGB
    .CMOS_VALID                        (                          ),//Data Enable
    .CMOS_FPS_DATA                     (                          ) //(cmos_fps_data)cmos frame rate
);

//-----------------------------------------------------------------
wire                                    CMOS2_WE                   ;//data write enable
wire                   [  15:0]         CMOS2_DATA_16              ;//cmos RGB 16bits 
CMOS_Capture u2_CMOS_Capture(
	//Global Clock
    .iCLK                              (Clk_camera                ),//24MHz
    .iRST_N                            (DLY_RST_0                 ),//global reset
	//I2C Initilize Done
    .Init_Done                         (Cmos2_Config_Done         ),//Init Done
	//Sensor Interface
    .CMOS_XCLK                         (                          ),//cmos
    .CMOS_PCLK                         (CMOS2_PCLK                ),//24MHz
    .CMOS_iDATA                        (CMOS2_D                   ),//CMOS Data
    .CMOS_VSYNC                        (CMOS2_VSYNC               ),//L: Vaild
    .CMOS_HREF                         (CMOS2_HREF                ),//H: Vaild
	//Ouput Sensor Data
    .CMOS_oCLK                         (CMOS2_WE                  ),//Data PCLK
    .CMOS_oDATA                        (CMOS2_DATA_16             ),//16Bits RGB
    .CMOS_VALID                        (                          ),//Data Enable
    .CMOS_FPS_DATA                     (                          ) //(cmos_fps_data)cmos frame rate
);

//-----------------------------------------------------------------
color_bar u_color_bar (
    //	Host Side
    .iRed                              (VGA_iRed                  ),
    .iGreen                            (VGA_iGreen                ),
    .iBlue                             (VGA_iBlue                 ),
    .oCoord_X                          (X_ADDR                    ),
    .oCoord_Y                          (Y_ADDR                    ),
	//	VGA Side
    .oVGA_R                            (color_bar_rgb[15:11]      ),
    .oVGA_G                            (color_bar_rgb[10:5]       ),
    .oVGA_B                            (color_bar_rgb[4:0]        ),
    .oVGA_H_SYNC                       (color_bar_hs              ),
    .oVGA_V_SYNC                       (color_bar_vs              ),
    .oVGA_SYNC                         (                          ),
    .oVGA_BLANK                        (                          ),
    .oVGA_CLOCK                        (                          ),
    .oVGA_DE                           (color_bar_de              ),
	//	Control Signal
    .iCLK                              (VGA_CTRL_CLK              ),
    .rst                               (~initial_en               ) 
);

//------------------------------------------------------------------
wire                                    SDRAM_oCLK                 ;
wire                                    WR1_LOAD                   ;
wire                                    WR2_LOAD                   ;
wire                                    RD1_LOAD                   ;
Sdram_Control_4Port u_Sdram_Control_4Port (                         //16M*16bit=256Mbit(16_0000*16=256_0000)
    .REF_CLK                           (CLOCK_50                  ),
    .RESET_N                           (RST_N                     ),
    .CLK                               (SDRAM_oCLK                ),
	//*********************FIFO Write Side 1**********************//
    .WR1_DATA                          (CMOS1_DATA_16             ),
    .WR1                               (CMOS1_WE                  ),
    .WR1_ADDR                          (0                         ),
    .WR1_LENGTH                        (9'h100                    ),//'d256
    .WR1_LOAD                          (WR1_LOAD                  ),
    .WR1_CLK                           (CMOS1_PCLK                ),

	//*********************FIFO Write Side 2**********************//
    .WR2_DATA                          (CMOS2_DATA_16             ),
    .WR2                               (CMOS2_WE                  ),
    .WR2_ADDR                          (22'h100000                ),//'d104_8576
    .WR2_LENGTH                        (9'h100                    ),//'d256
    .WR2_LOAD                          (WR2_LOAD                  ),
    .WR2_CLK                           (CMOS2_PCLK                ),

	//*********************FIFO Read Side 1**********************//
    .RD1_DATA                          (Read_DATA1                ),
    .RD1                               (Read1                     ),
    .RD1_ADDR                          (0                         ),
    .RD1_LENGTH                        (9'h100                    ),//'d256
    .RD1_LOAD                          (RD1_LOAD                  ),
    .RD1_CLK                           (VGA_CTRL_CLK              ),

	//*********************FIFO Read Side 2**********************//
    .RD2_DATA                          (Read_DATA2                ),
    .RD2                               (Read2                     ),
    .RD2_ADDR                          (22'h100000                ),//'d104_8576
    .RD2_LENGTH                        (9'h100                    ),//'d256
    .RD2_LOAD                          (!DLY_RST_0                ),
    .RD2_CLK                           (VGA_CTRL_CLK              ),

	//*********************   SDRAM Side   **********************//
    .SA                                (DRAM_ADDR                 ),
    .BA                                ({DRAM_BA_1,DRAM_BA_0}     ),
    .CS_N                              (DRAM_CS_N                 ),
    .CKE                               (DRAM_CKE                  ),
    .RAS_N                             (DRAM_RAS_N                ),
    .CAS_N                             (DRAM_CAS_N                ),
    .WE_N                              (DRAM_WE_N                 ),
    .DQ                                (DRAM_DQ                   ),
    .DQM                               ({DRAM_UDQM,DRAM_LDQM}     ),
    .SDR_CLK                           (DRAM_CLK                  ) 
);

//------------------------------------------------------------------
// 取得上升沿并作为下一级的触发信号
getPos u_getPos(
    // sys
    .SDRAM_oCLK                        (SDRAM_oCLK                ),
    .RST_N                             (RST_N                     ),
    // CMOS1_VSYNC  -->  WR1_LOAD
    .CMOS1_VSYNC                       (CMOS1_VSYNC               ),
    .WR1_LOAD                          (WR1_LOAD                  ),
    // CMOS2_VSYNC  -->  WR2_LOAD
    .CMOS2_VSYNC                       (CMOS2_VSYNC               ),
    .WR2_LOAD                          (WR2_LOAD                  ),
    // VGA_VS       -->  RD1_LOAD
    .VGA_VS                            (VGA_VS                    ),
    .RD1_LOAD                          (RD1_LOAD                  ) 
);

//------------------------------------------------------------------
// key按键 KEY1 管脚PIN_M15
key u_key(
    .clk                               (CLOCK_50                  ),
    .key                               (iKEY                      ),
    .key_value                         (key_value                 ) 
);

//------------------------------------------------------------------
// sobel算子
sobel_top u_sobel_top(
    // sys
    .vga_clk                           (VGA_CTRL_CLK              ),
    // KEY
    .iKey_value                        (key_value[10:0]           ),
    // input
    .iVGA_de                           (color_bar_de              ),
    .iVGA_hs                           (color_bar_hs              ),
    .iVGA_vs                           (color_bar_vs              ),
    .iRGB_565                          (color_bar_rgb[15:0]       ),
    // output
    .oVGA_hs                           (sobel_hs                  ),
    .oVGA_vs                           (sobel_vs                  ),
    .oVGA_de                           (sobel_de                  ),
    .oVGA_565                          (sobel_data[15:0]          ) 
);

assign VGA_R = sobel_data[15:11];
assign VGA_G = sobel_data[10:5];
assign VGA_B = sobel_data[4:0];
assign VGA_HS = sobel_hs;
assign VGA_VS = sobel_vs;

//------------------------------------------------------------------
// 板载数码管
seg_dynamic #(
    .CNT_MAX                           (16'd49_999                ) //数码管刷新时间计数最大值
)
u_seg_dynamic(
    //sys input
    .clk                               (CLOCK_50                  ),
    .rstn                              (RST_N                     ),
    //input
    .data                              (key_value                 ),
    .point                             (6'b000_000                ),
    .sign                              (1'b0                      ),
    .seg_en                            (1'b0                      ),
    //output
    .SEL                               (SEL                       ),
    .SEG                               (DIG                       ) 
);

endmodule