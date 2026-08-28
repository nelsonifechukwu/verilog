module alu4(
    input wire [3:0] a,
    input wire [3:0] b,
    input wire [1:0] op,
    output reg [3:0] y
);
    always @(*) begin
        case (op)
            2'b00: y = a + b;
            2'b01: y = a - b;
            2'b10: y = a & b;
            2'b11: y = a | b;
            default: y = 4'b0000;
        endcase
    end
endmodule