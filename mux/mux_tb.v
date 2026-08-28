`timescale 1ns/1ps

module mux2_tb;

    reg a;
    reg b;
    reg sel;

    wire y;

    integer i;

    mux2 dut (
        .a(a),
        .b(b),
        .sel(sel),
        .y(y)
    );

    initial begin
        $display("a b sel | y");
        $display("----------");

        for (i = 0; i < 8; i = i + 1) begin
            {a, b, sel} = i[2:0];

            #1;

            if (y !== (sel ? b : a)) begin
                $display("FAIL");
                $finish;
            end

            $display("%b %b  %b  | %b", a, b, sel, y);
        end

        $display("ALL MUX TESTS PASSED");
        $finish;
    end

endmodule