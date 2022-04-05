//每按一下key_value+1
//key_value从80到170

module key
(
    input                               clk                        ,
    input                               key                        ,
    output reg         [  10:0]         key_value                   
);

reg                                     key_reg                    ;
reg                    [  19:0]         timer                      ;

    parameter                           cnt_max = 20'd20_0000      ;

    always@(posedge clk)
        begin
            key_reg <= key;
            if(key != key_reg)
                timer <= cnt_max;
            else
                begin
                    if(timer > 20'd0)
                        timer <= timer -1'b1;
                    else
                        timer <= 20'd0;
                end
        end

    always@(posedge clk)begin
        if(timer == 20'b1 && key_reg == 1'b1)begin
            key_value <= key_value + 2;
            if(key_value < 80 || key_value > 170)
                key_value <= 80;
        end
    end

endmodule
