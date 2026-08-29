module fifo();

    reg [7:0] mem [0:4];
    reg [1:0] w_ptr;
    reg [1:0] r_ptr;
    reg [2:0] count; //count count must represent 0 ... 4 (5 values), so we need more bits as 2 bits only allow us to represent 4 values.

endmodule