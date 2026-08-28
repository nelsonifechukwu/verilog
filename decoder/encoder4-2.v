module encoder4to2 (
    input  wire [3:0] a,
    output reg  [1:0] y
);

    always @(*) begin
        case (a)
            4'b0001: y = 2'b00;
            4'b0010: y = 2'b01;
            4'b0100: y = 2'b10;
            4'b1000: y = 2'b11;
            default: y = 2'b00;
        endcase
    end

endmodule