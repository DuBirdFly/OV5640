module shift_custom #(
    parameter                           ROW = 30                   ,
    parameter                           COL = 30                    
)(
    // sys
    input  wire                         vga_clk                    ,
    input  wire                         rst_n                      ,
    // input
    input  wire        [   7:0]         din                        ,
    input  wire                         din_vld                    ,
    // output
    output wire        [   7:0]         px3,px5                    ,
    output reg         [   7:0]         px1,px2,px4                  
);

reg                                     wrreq                      ;
reg                                     rdreq                      ;
reg                    [   7:0]         cnt                        ;

assign px5 = din;

// cnt
always @(posedge vga_clk or negedge rst_n) begin
    if (!rst_n)
        cnt <= 1'b0;
    else if (din_vld && cnt < COL)
        cnt <= cnt + 1;
end

// wrreq
always @(negedge vga_clk or negedge rst_n) begin
    if (!rst_n)
        wrreq <= 1'b0;
    else if (din_vld)
        wrreq <= 1'b1;
end

// rdreq
always @(negedge vga_clk or negedge rst_n) begin
    if (!rst_n)
        rdreq <= 1'b0;
    else if (din_vld && cnt == COL)
        wrreq <= 1'b1;
end

// px1,px2,px4
always @(posedge vga_clk or negedge rst_n) begin
    if (!rst_n) begin
        px1 <= 1'b0;
        px2 <= 1'b0;
        px4 <= 1'b0;
    end
    else begin
        px1 <= px2;
        px2 <= px3;
        px4 <= din;
    end
end

// width = 8bits, deepth = 32words
// This FIFO is used for a delay of (COL - 1) clock cycles
fifo_line    fifo_line_inst (
    .clock                             (vga_clk                   ),
    .data                              (din[7:0]                  ),
    .rdreq                             (rdreq                     ),
    .wrreq                             (wrreq                     ),
    .q                                 (px3[7:0]                  ) 
);

endmodule
