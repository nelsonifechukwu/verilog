`timescale 1ns/1ps

module half_adder_tb;

    reg a, b;
    wire sum, carry;
    integer i;

    half_adder dut (
        .a(a),
        .b(b),
        .sum(sum),
        .carry(carry)
    );

    initial begin
        for (i = 0; i < 4; i = i + 1) begin
            {a,b} = i[1:0];
            #1;

            if ({carry,sum} !== (a + b)) begin
                $display("FAIL a=%b b=%b", a, b);
                $finish;
            end

            $display("%b + %b -> carry=%b sum=%b",
                     a, b, carry, sum);
        end

        $display("HALF ADDER PASSED");
        $finish;
    end

endmodule