//~ `New testbench
`timescale  1ns / 1ps

module tb_VGA_Controller;

// VGA_Controller Parameters
    parameter                           PERIOD  = 20               ;

//  Inputs
reg                    [   9:0]         iRed                   = 0 ;
reg                    [   9:0]         iGreen                 = 0 ;
reg                    [   9:0]         iBlue                  = 0 ;
reg                                     iCLK                   = 0 ;
reg                                     iRST_N                 = 0 ;

// VGA_Controller Outputs
wire                   [   9:0]         a_oCoord_X                 ;
wire                   [   9:0]         a_oCoord_Y                 ;
wire                                    a_oRequest                 ;
wire                   [   4:0]         a_oVGA_R                   ;
wire                   [   5:0]         a_oVGA_G                   ;
wire                   [   4:0]         a_oVGA_B                   ;
wire                                    a_oVGA_H_SYNC              ;
wire                                    a_oVGA_V_SYNC              ;
wire                                    a_oVGA_SYNC                ;
wire                                    a_oVGA_BLANK               ;
wire                                    a_oVGA_CLOCK               ;

// VGA_Controller Outputs
// color_bar Outputs
wire                   [  11:0]         b_oCoord_X                 ;
wire                   [  11:0]         b_oCoord_Y                 ;
wire                   [   4:0]         b_oVGA_R                   ;
wire                   [   5:0]         b_oVGA_G                   ;
wire                   [   4:0]         b_oVGA_B                   ;
wire                                    b_oVGA_H_SYNC              ;
wire                                    b_oVGA_V_SYNC              ;
wire                                    b_oVGA_SYNC                ;
wire                                    b_oVGA_BLANK               ;
wire                                    b_oVGA_CLOCK               ;
wire                                    b_oVGA_DE                  ;

initial begin
    forever #(PERIOD/2)  iCLK=~iCLK;
end

initial begin
    #(PERIOD*2) iRST_N  =  1;
end

VGA_Controller  u_VGA_Controller (
    .iRed                              (iRed         [   9:0]     ),
    .iGreen                            (iGreen       [   9:0]     ),
    .iBlue                             (iBlue        [   9:0]     ),
    .iCLK                              (iCLK                      ),
    .iRST_N                            (iRST_N                    ),

    .oCoord_X                          (a_oCoord_X     [   9:0]   ),
    .oCoord_Y                          (a_oCoord_Y     [   9:0]   ),
    .oRequest                          (a_oRequest                ),
    .oVGA_R                            (a_oVGA_R       [   4:0]   ),
    .oVGA_G                            (a_oVGA_G       [   5:0]   ),
    .oVGA_B                            (a_oVGA_B       [   4:0]   ),
    .oVGA_H_SYNC                       (a_oVGA_H_SYNC             ),
    .oVGA_V_SYNC                       (a_oVGA_V_SYNC             ),
    .oVGA_SYNC                         (a_oVGA_SYNC               ),
    .oVGA_BLANK                        (a_oVGA_BLANK              ),
    .oVGA_CLOCK                        (a_oVGA_CLOCK              ) 
);

color_bar u_color_bar (
    .iRed                              (iRed         [   9:0]     ),
    .iGreen                            (iGreen       [   9:0]     ),
    .iBlue                             (iBlue        [   9:0]     ),
    .iCLK                              (iCLK                      ),
    .rst                               (~iRST_N                   ),

    .oCoord_X                          (b_oCoord_X     [  11:0]   ),
    .oCoord_Y                          (b_oCoord_Y     [  11:0]   ),
    .oVGA_R                            (b_oVGA_R       [   4:0]   ),
    .oVGA_G                            (b_oVGA_G       [   5:0]   ),
    .oVGA_B                            (b_oVGA_B       [   4:0]   ),
    .oVGA_H_SYNC                       (b_oVGA_H_SYNC             ),
    .oVGA_V_SYNC                       (b_oVGA_V_SYNC             ),
    .oVGA_SYNC                         (b_oVGA_SYNC               ),
    .oVGA_BLANK                        (b_oVGA_BLANK              ),
    .oVGA_CLOCK                        (b_oVGA_CLOCK              ),
    .oVGA_DE                           (b_oVGA_DE                 ) 
);

initial begin
    #(800*500*PERIOD*2);
    $stop;
end

endmodule