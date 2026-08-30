module uart_tx_simple (
    input  wire       clk,
    input  wire       reset,

    input  wire       start,
    input  wire       tick,

    input  wire [7:0] data,

    output reg        tx,
    output reg        busy
);

    reg [1:0] state;

    reg [7:0] shift_reg;
    reg [2:0] bit_count;

    parameter IDLE  = 2'b00;
    parameter START = 2'b01;
    parameter DATA  = 2'b10;
    parameter STOP  = 2'b11;


    always @(posedge clk) begin

        if (reset) begin

            state     <= IDLE;
            tx        <= 1'b1;
            busy      <= 1'b0;
            bit_count <= 0;

        end else begin

            case (state)

                START: begin
                    tx <= 1'b0;
                    if (tick) 
                        state<= DATA;
                end
                
                STOP: begin
                    tx <= 1b'1; //pull tx high
                    if(tick) begin
                        state <= IDLE; //reset state to UDLE
                        busy <= 1'b0; //tx line is no longer busy
                    end
                end

            endcase 

endmodule