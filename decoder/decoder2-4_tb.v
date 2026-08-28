`timescale 1ns/1ps

module decoder2to4_tb;

    reg  [1:0] a;
    wire [3:0] y;

    integer i;

    decoder2to4 dut (
        .a(a),
        .y(y)
    );

    initial begin
        for (i = 0; i < 4; i = i + 1) begin
            a = i[1:0];

            #1;

            case (a)
                2'b00: if (y !== 4'b0001) $display("FAIL");
                2'b01: if (y !== 4'b0010) $display("FAIL");
                2'b10: if (y !== 4'b0100) $display("FAIL");
                2'b11: if (y !== 4'b1000) $display("FAIL");
            endcase

            $display("a=%b -> y=%b", a, y);
        end

        $display("DECODER PASSED");
        $finish;
    end

endmodule