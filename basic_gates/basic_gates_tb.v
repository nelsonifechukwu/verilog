`timescale 1ns/1ps

module basic_gates_tb;

    reg a;
    reg b;

    wire and_y;
    wire or_y;
    wire xor_y;
    wire nand_y;
    wire nor_y;
    wire not_a;

    integer i;

    basic_gates dut (
        .a(a),
        .b(b),
        .and_y(and_y),
        .or_y(or_y),
        .xor_y(xor_y),
        .nand_y(nand_y),
        .nor_y(nor_y),
        .not_a(not_a)
    );

    initial begin
        $display("A B | AND OR XOR NAND NOR NOT_A");
        $display("--------------------------------");

        for (i = 0; i < 4; i = i + 1) begin
            {a, b} = i[1:0];

            #1;

            if (
                (and_y  !== (a & b))   ||
                (or_y   !== (a | b))   ||
                (xor_y  !== (a ^ b))   ||
                (nand_y !== ~(a & b))  ||
                (nor_y  !== ~(a | b))  ||
                (not_a  !== ~a)
            ) begin
                $display("FAIL: a=%b b=%b", a, b);
                $finish;
            end

            $display(
                "%b %b |  %b   %b   %b    %b    %b    %b",
                a, b,
                and_y, or_y, xor_y,
                nand_y, nor_y, not_a
            );
        end

        $display("--------------------------------");
        $display("ALL TESTS PASSED");

        $finish;
    end

endmodule