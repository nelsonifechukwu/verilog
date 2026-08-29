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
        reset = 1'b0;
        start = 1'b1;
        stop = 1'b1;

        // @(posedge clk); 
        // #1;
        
        // if (running)
        //     $display("FAILED, reset is 1");
        // else
        //     $display("Reset test passed. Running = %b", running);

          // Print at t = 0
        $strobe("time=%0t ns, clk=%b, running=%b", $time, clk, running);

        repeat (5) begin
            #5;
          // Print at t = 0
            $strobe("time=%0t ns, clk=%b, running=%b",
                $time, clk, running);
        end
        
        $finish;
    end
endmodule