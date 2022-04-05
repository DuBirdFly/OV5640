module getPosedge (                                                 //捕获 iWire 的上升沿，2个clk的延时，为了确保数据的稳定
    input  wire                         clk                        ,//50MHz
    input  wire                         rst_n                      ,
    input  wire                         iWire                      ,
    output wire                         oGetPosedge                 
);

reg                                     iWire_reg1                 ;
reg                                     iWire_reg2                 ;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        iWire_reg1 <= 1'b0;
        iWire_reg2 <= 1'b0;
    end
    else begin
        iWire_reg1 <= iWire;
        iWire_reg2 <= iWire_reg1;
    end
end

assign oGetPosedge = ({iWire_reg1,iWire_reg2} == 2'b01) ? 1'b1 : 1'b0;

endmodule
