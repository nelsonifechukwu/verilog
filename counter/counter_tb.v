`timescale 1ns/1ps
module counter_tb;

    reg reset;
    reg clk;
    wire [3:0] count;

    counter4 dut(
        .reset(reset),
        .count(count),
        .enable(!reset),
        .clk(clk)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1'b1;

        @(posedge clk);
        #1;

        if (count == 4'b0000) 
            $display("SUCCESS! Count = %b", count);
        else 
            $display("FAILED! Count = %b", count);
        $finish;
    end
endmodule