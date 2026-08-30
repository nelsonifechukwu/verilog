`timescale 1ns/1ps

module full_adder_tb;

    reg a, b, cin;
    wire sum, cout;

    integer i;

    full_adder dut (
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sum),
        .cout(cout)
    );

    initial begin

        for (i = 0; i < 8; i = i + 1) begin

            {a,b,cin} = i[2:0];

            #1;

            if ({cout,sum} !== (a + b + cin)) begin
                $display("FAIL: a=%b b=%b cin=%b",
                         a,b,cin);
                $finish;
            end

            $display(
                "%b + %b + %b -> cout=%b sum=%b",
                a,b,cin,cout,sum
            );

        end

        $display("FULL ADDER PASSED");
        $finish;
    end

endmodule