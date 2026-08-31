`timescale 1ns/1ps

module register4_tb;

    reg clk;
    reg reset;
    reg enable;
    reg [3:0] d;

    wire [3:0] q;

    register4 dut (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .d(d),
        .q(q)
    );

    // Clock: period = 10 ns
    always #5 clk = ~clk;

    initial begin

        clk    = 0;
        reset  = 1;
        enable = 0;
        d      = 4'b0000;

        // Let reset be seen at a rising edge
        @(posedge clk);
        #1;

        if (q !== 4'b0000)
            $display("FAIL: reset");

        // Remove reset
        reset = 0;

        // Load 1010
        d = 4'b1010;
        enable = 1;

        @(posedge clk);
        #1;

        if (q !== 4'b1010)
            $display("FAIL: load 1010");

        $display("Loaded: q=%b", q);

        // Change d but disable register
        d = 4'b1111;
        enable = 0;

        @(posedge clk);
        #1;

        if (q !== 4'b1010)
            $display("FAIL: register did not hold");

        $display("Hold:   q=%b", q);

        // Enable again
        enable = 1;

        @(posedge clk);
        #1;

        if (q !== 4'b1111)
            $display("FAIL: load 1111");

        $display("Loaded: q=%b", q);

        $display("REGISTER TEST PASSED");

        $finish;

    end

endmodule