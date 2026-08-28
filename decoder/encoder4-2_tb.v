`timescale 1ns/1ps

module encoder4to2_tb;

    reg  [3:0] a;
    wire [1:0] y;

    encoder4to2 dut (
        .a(a),
        .y(y)
    );

    initial begin

        a = 4'b0001;
        #1;
        if (y !== 2'b00) $display("FAIL");
        $display("a=%b -> y=%b", a, y);

        a = 4'b0010;
        #1;
        if (y !== 2'b01) $display("FAIL");
        $display("a=%b -> y=%b", a, y);

        a = 4'b0100;
        #1;
        if (y !== 2'b10) $display("FAIL");
        $display("a=%b -> y=%b", a, y);

        a = 4'b1000;
        #1;
        if (y !== 2'b11) $display("FAIL");
        $display("a=%b -> y=%b", a, y);

        $display("ENCODER PASSED");
        $finish;
    end

endmodule
