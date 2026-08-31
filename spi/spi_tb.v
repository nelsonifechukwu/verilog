`timescale 1ns/1ps

module spi_master_tb;

    reg clk;
    reg reset;
    reg start;

    reg [7:0] tx_data;

    reg miso;

    wire mosi;
    wire sclk;
    wire cs_n;
    wire busy;

    wire [7:0] rx_data;

    reg [7:0] slave_data;
    integer slave_bit;


    spi_master #(
        .CLK_DIV(2)
    ) dut (
        .clk(clk),
        .reset(reset),

        .start(start),
        .tx_data(tx_data),
        .rx_data(rx_data),

        .miso(miso),

        .mosi(mosi),
        .sclk(sclk),
        .cs_n(cs_n),
        .busy(busy)
    );


    always #5 clk = ~clk;


    // Fake SPI slave
    always @(negedge sclk) begin

        if (!cs_n) begin

            if (slave_bit > 0) begin
                slave_bit = slave_bit - 1;
                miso = slave_data[slave_bit];
            end

        end

    end


    initial begin

        clk = 0;
        reset = 1;
        start = 0;

        tx_data = 8'b10110010;

        slave_data = 8'b11001010;
        slave_bit = 7;

        miso = slave_data[7];


        @(posedge clk);
        #1;

        reset = 0;


        // Start transaction
        start = 1;

        @(posedge clk);
        #1;

        start = 0;


        // Wait until transfer finishes
        wait (busy == 0);

        #1;

        $display("TX = %b", tx_data);
        $display("RX = %b", rx_data);


        if (rx_data !== slave_data)
            $display("FAIL");

        else
            $display("SPI TEST PASSED");


        $finish;

    end

endmodule