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
                
                IDLE: begin
                    tx <= 1'b1; //tx remains high
                    busy <= 1'b0; //not yet busy
                    if (start) begin
                        shift_reg <= data; //this is done here cause this is where the UART receives a transmission request and then immediately holds the data it will transmit.
                        bit_count = 0;
    
                        busy <= 1'b1; //tx line is busy
                        state <= START;
                    end
                end

                START: begin
                    tx <= 1'b0; //pull tx low
                    if (tick) 
                        state <= DATA;
                end

                DATA: begin
                    tx <= shift_reg[0]; //send lsb
                    
                    if (tick) begin
                        shift_reg <= shift_reg >> 1; //shift data so next lsb can be selected.
                        if (bit_count == 7) //check to send all 8bits
                            state <= STOP;
                        else 
                            bit_count = bit_count + 1;    
                    end
                end

                STOP: begin
                    tx <= 1'b1; //pull tx high
                    if(tick) begin
                        state <= IDLE; //reset state to IDLE
                        busy <= 1'b0; //tx line is no longer busy
                    end
                end
        endcase 
        end
    end

endmodule