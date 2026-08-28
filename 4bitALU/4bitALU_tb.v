`timescale 1ns/1ps
module alu4_tb;

    reg [3:0] a, b; 
    reg [1:0] op;
    reg [3:0] y;

    integer i;

    alu4 dut(
        .a(a),
        .b(b),
        .op(op),
        .y(y)
    );

    initial begin
        a = 4'b0101;
        b = 4'b0100;
        for (i=0; i<4; i=i+1) begin

            op = i[1:0];
            
            #1
            if ((op == 2'b00) && (y !== (a + b))) begin
                $display("FAIL: op=%b", op);
            end
            if ((op == 2'b01) && (y !== (a - b))) begin
                $display("FAIL: op=%b", op);
            end
            if ((op == 2'b10) && (y !== (a & b))) begin
                $display("FAIL: op=%b", op);
            end
            if ((op == 2'b11) && (y !== (a | b))) begin
                $display("FAIL: op=%b", op);
            end   
        end
        $finish;
    end

endmodule