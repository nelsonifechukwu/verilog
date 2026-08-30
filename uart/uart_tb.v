module(
    reg clk, reset, start, tick, [7:0] data,
    wire tx
);

    uart_tx_simple dut(
        .clk(clk),
        .reset(reset),
        .start(start),
        .tick(tick),
        .data(data),
        .tx(tx)
    );

    always #5 clk = ~clk;

    initial begin

    
    end


endmodule