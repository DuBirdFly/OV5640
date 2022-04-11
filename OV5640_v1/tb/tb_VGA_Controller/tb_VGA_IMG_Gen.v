// reg [7:0] data_men[16383:0]          ;//128*128=16384
// initial
//     $readmemh("D:/ZPF_Document/ZPF_FPGA/MyCore/16_Sobel/matlab/bird.txt",data_men);
// task rx_byte();
//     integer j;
//     for (j=0; j<16384; j=j+1)
//         rx_bit(data_men[j]);
// endtask

//~ `New testbench
`timescale  1ns / 1ps

module tb_TOP;















endmodule