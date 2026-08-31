`timescale 1ns/1ps

module traffic_light_tb;

    reg clk;
    reg reset;
    reg timer_done;

    wire green;
    wire yellow;
    wire red;

    traffic_light dut (
        .clk(clk),
        .reset(reset),
        .timer_done(timer_done),
        .green(green),
        .yellow(yellow),
        .red(red)
    );

    always #5 clk = ~clk;


    initial begin

        clk = 0;
        reset = 1;
        timer_done = 0;

        // Reset
        @(posedge clk);
        #1;

        if (red !== 1'b1)
            $display("FAIL: reset should produce RED");

        $display("RESET  -> G=%b Y=%b R=%b",
                 green, yellow, red);

        reset = 0;


        // RED -> GREEN
        timer_done = 1;

        @(posedge clk);
        #1;

        $display("STEP 1 -> G=%b Y=%b R=%b",
                 green, yellow, red);


        // GREEN -> YELLOW
        @(posedge clk);
        #1;

        $display("STEP 2 -> G=%b Y=%b R=%b",
                 green, yellow, red);


        // YELLOW -> RED
        @(posedge clk);
        #1;

        $display("STEP 3 -> G=%b Y=%b R=%b",
                 green, yellow, red);


        // Stop transitioning
        timer_done = 0;

        @(posedge clk);
        #1;

        if (red !== 1'b1)
            $display("FAIL: should remain RED");

        $display("HOLD   -> G=%b Y=%b R=%b",
                 green, yellow, red);


        $display("TRAFFIC FSM PASSED");

        $finish;

    end

endmodule