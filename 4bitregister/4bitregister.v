module register4 (
    input  wire       clk,
    input  wire       reset,
    input  wire       enable,
    input  wire [3:0] d,
    output reg  [3:0] q
);

    always @(posedge clk) begin
        if (reset)
            q <= 4'b0000;
        else if (enable)
            q <= d;
    end

endmodule