// 取得上升沿并作为下一级的触发信号
module getPos (
    // sys
    input  wire                         SDRAM_oCLK                 ,//  100MHz(低速为50MHz, 高速为133MHz)
    input  wire                         RST_N                      ,
    // CMOS1_VSYNC  -->  WR1_LOAD
    input  wire                         CMOS1_VSYNC                ,
    output wire                         WR1_LOAD                   ,
    // CMOS2_VSYNC  -->  WR2_LOAD
    input  wire                         CMOS2_VSYNC                ,
    output wire                         WR2_LOAD                   ,
    // VGA_VS       -->  RD1_LOAD
    input  wire                         VGA_VS                     ,
    output wire                         RD1_LOAD                    
);

getPosedge u1_getPosedge (
    .clk                               (SDRAM_oCLK                ),
    .rst_n                             (RST_N                     ),
    .iWire                             (CMOS1_VSYNC               ),
    .oGetPosedge                       (WR1_LOAD                  ) 
);

getPosedge u2_getPosedge (
    .clk                               (SDRAM_oCLK                ),
    .rst_n                             (RST_N                     ),
    .iWire                             (CMOS2_VSYNC               ),
    .oGetPosedge                       (WR2_LOAD                  ) 
);

getPosedge u3_getPosedge (
    .clk                               (SDRAM_oCLK                ),
    .rst_n                             (RST_N                     ),
    .iWire                             (VGA_VS                    ),
    .oGetPosedge                       (RD1_LOAD                  ) 
);

endmodule
