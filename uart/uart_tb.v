`timescale 1ns/1ps
module uart_tb;

    reg clk, reset, start, tick;
    reg [7:0] data;
    wire tx;

    uart_tx_simple dut(
        .clk(clk),
        .reset(reset),
        .start(start),
        .tick(tick),
        .data(data),
        .tx(tx)
    );

    always #5 clk = ~clk;
    always #5 tick = ~tick;

    initial begin
        data = 8'b11001101;
        start = 1;
        reset = 1;
        clk = 0;
        tick = 0;

        @(negedge clk); 
        reset = 0;

        repeat (12) begin
            @(posedge clk); 
            $display("DATA: %b", tx);
        end
    $finish;
    end


endmodule