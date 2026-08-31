module i2c_master_simple (
    input  wire       clk,
    input  wire       reset,
    input  wire       tick,

    input  wire       start,
    input  wire [6:0] address,
    input  wire [7:0] data,

    output reg        scl,
    inout  wire       sda,

    output reg        busy,
    output reg        ack_error
);

    reg sda_drive_low;

    reg [2:0] state;
    reg [1:0] phase;

    reg [7:0] shift_reg;
    reg [2:0] bit_count;


    parameter IDLE      = 3'd0;
    parameter START_ST  = 3'd1;
    parameter SEND_ADDR = 3'd2;
    parameter ACK_ADDR  = 3'd3;
    parameter SEND_DATA = 3'd4;
    parameter ACK_DATA  = 3'd5;
    parameter STOP_ST   = 3'd6;


    // Open-drain SDA:
    //
    // drive_low = 1 → drive 0
    // drive_low = 0 → release line
    assign sda = sda_drive_low ? 1'b0 : 1'bz;


    always @(posedge clk) begin

        if (reset) begin

            scl           <= 1'b1;
            sda_drive_low <= 1'b0;

            busy          <= 1'b0;
            ack_error     <= 1'b0;

            state         <= IDLE;
            phase         <= 0;

            shift_reg     <= 0;
            bit_count     <= 0;

        end else begin

            // ---------------- IDLE ----------------
            if (state == IDLE) begin

                scl           <= 1'b1;
                sda_drive_low <= 1'b0;
                busy          <= 1'b0;

                if (start) begin

                    busy      <= 1'b1;
                    ack_error <= 1'b0;

                    shift_reg <= {address, 1'b0};
                    bit_count <= 7;

                    phase <= 0;
                    state <= START_ST;

                end

            end


            else if (tick) begin

                case (state)

                    // -------- START --------
                    START_ST: begin

                        if (phase == 0) begin

                            // SDA high -> low while SCL high
                            scl           <= 1'b1;
                            sda_drive_low <= 1'b1;

                            phase <= 1;

                        end else begin

                            scl   <= 1'b0;
                            phase <= 0;
                            state <= SEND_ADDR;

                        end

                    end


                    // -------- ADDRESS --------
                    SEND_ADDR: begin

                        if (phase == 0) begin

                            scl <= 1'b0;

                            // 0 = drive low
                            // 1 = release SDA
                            sda_drive_low <= ~shift_reg[bit_count];

                            phase <= 1;

                        end else begin

                            // Receiver samples bit
                            scl <= 1'b1;

                            phase <= 0;

                            if (bit_count == 0)
                                state <= ACK_ADDR;
                            else
                                bit_count <= bit_count - 1;

                        end

                    end


                    // -------- ADDRESS ACK --------
                    ACK_ADDR: begin

                        if (phase == 0) begin

                            scl <= 1'b0;

                            // Master releases SDA
                            sda_drive_low <= 1'b0;

                            phase <= 1;

                        end else begin

                            // Sample slave ACK
                            scl <= 1'b1;

                            if (sda != 1'b0)
                                ack_error <= 1'b1;

                            shift_reg <= data;
                            bit_count <= 7;

                            phase <= 0;
                            state <= SEND_DATA;

                        end

                    end


                    // -------- DATA --------
                    SEND_DATA: begin

                        if (phase == 0) begin

                            scl <= 1'b0;

                            sda_drive_low <= ~shift_reg[bit_count];

                            phase <= 1;

                        end else begin

                            scl <= 1'b1;
                            phase <= 0;

                            if (bit_count == 0)
                                state <= ACK_DATA;
                            else
                                bit_count <= bit_count - 1;

                        end

                    end


                    // -------- DATA ACK --------
                    ACK_DATA: begin

                        if (phase == 0) begin

                            scl <= 1'b0;
                            sda_drive_low <= 1'b0;

                            phase <= 1;

                        end else begin

                            scl <= 1'b1;

                            if (sda != 1'b0)
                                ack_error <= 1'b1;

                            phase <= 0;
                            state <= STOP_ST;

                        end

                    end


                    // -------- STOP --------
                    STOP_ST: begin

                        if (phase == 0) begin

                            scl <= 1'b0;
                            sda_drive_low <= 1'b1;

                            phase <= 1;

                        end

                        else if (phase == 1) begin

                            // SDA still low
                            // Bring SCL high
                            scl <= 1'b1;

                            phase <= 2;

                        end

                        else begin

                            // SDA low -> high while SCL high
                            sda_drive_low <= 1'b0;

                            busy  <= 1'b0;
                            phase <= 0;
                            state <= IDLE;

                        end

                    end


                    default: begin

                        state <= IDLE;

                    end

                endcase

            end

        end

    end

endmodule