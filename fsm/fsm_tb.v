`timescale 1ns/1ps
module fsm_tb;
    reg clk, reset, start, stop;
    wire running;


    simple_fsm dut(
        .reset(reset),
        .start(start),
        .stop(stop),
        .running(running),
        .clk(clk)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 1'b0;
        reset = 1'b1;
        start = 1'b0;
        stop = 1'b0;

        @(posedge clk); 
        #1;
        
        if (running)
            $display("FAILED, reset is 1");
        else
            $display("Reset test passed. Running = %b", running);
        $finish;
    end
endmodule