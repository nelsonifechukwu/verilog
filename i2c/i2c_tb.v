`timescale 1ns/1ps

module i2c_master_simple_tb;

    reg clk;
    reg reset;
    reg tick;
    reg start;

    reg [6:0] address;
    reg [7:0] data;

    wire scl;
    tri1 sda;

    wire busy;
    wire ack_error;


    // Fake slave can also pull SDA low
    reg slave_drive_low;

    assign sda = slave_drive_low ? 1'b0 : 1'bz;


    i2c_master_simple dut (
        .clk(clk),
        .reset(reset),
        .tick(tick),

        .start(start),
        .address(address),
        .data(data),

        .scl(scl),
        .sda(sda),

        .busy(busy),
        .ack_error(ack_error)
    );


    always #5 clk = ~clk;


    // Generate tick every 20 ns
    always begin
        #20 tick = 1;
        #10 tick = 0;
    end


    // Fake I2C slave
    initial begin

        integer i;
        reg [7:0] received_address;
        reg [7:0] received_data;

        slave_drive_low = 0;

        wait(reset == 0);

        // Detect START:
        // SDA falls while SCL is high
        @(negedge sda);


        // Receive 8 address bits
        for (i = 7; i >= 0; i = i - 1) begin

            @(posedge scl);
            received_address[i] = sda;

        end


        // ACK address
        @(negedge scl);

        slave_drive_low = 1;

        @(posedge scl);

        @(negedge scl);

        slave_drive_low = 0;


        // Receive 8 data bits
        for (i = 7; i >= 0; i = i - 1) begin

            @(posedge scl);
            received_data[i] = sda;

        end


        // ACK data
        @(negedge scl);

        slave_drive_low = 1;

        @(posedge scl);

        @(negedge scl);

        slave_drive_low = 0;


        $display(
            "Slave received address byte = %b",
            received_address
        );

        $display(
            "Slave received data byte    = %b",
            received_data
        );

    end


    initial begin

        clk   = 0;
        tick  = 0;

        reset = 1;
        start = 0;

        address = 7'b1010011;
        data    = 8'b11001010;


        @(posedge clk);
        #1;

        reset = 0;


        start = 1;

        @(posedge clk);
        #1;

        start = 0;


        wait(busy == 1);

        wait(busy == 0);

        #5;


        if (ack_error)
            $display("FAIL: NACK detected");

        else
            $display("I2C TEST PASSED");


        $finish;

    end

endmodule