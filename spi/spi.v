module spi_master #(
    parameter CLK_DIV = 2
)(
    input  wire       clk,
    input  wire       reset,

    input  wire       start,
    input  wire [7:0] tx_data,
    output reg  [7:0] rx_data,

    input  wire       miso,

    output reg        mosi,
    output reg        sclk,
    output reg        cs_n,
    output reg        busy
);

    reg [7:0] tx_shift;
    reg [7:0] rx_shift;

    reg [2:0] bit_count;
    integer div_count;


    always @(posedge clk) begin

        if (reset) begin

            sclk      <= 0;
            cs_n      <= 1;
            busy      <= 0;

            mosi      <= 0;

            tx_shift  <= 0;
            rx_shift  <= 0;
            rx_data   <= 0;

            bit_count <= 0;
            div_count <= 0;

        end else begin

            // Start new transaction
            if (start && !busy) begin

                busy      <= 1;
                cs_n      <= 0;

                sclk      <= 0;

                tx_shift  <= tx_data;
                rx_shift  <= 0;

                bit_count <= 0;
                div_count <= 0;

                // First bit ready before first rising SCLK
                mosi <= tx_data[7];

            end


            else if (busy) begin

                if (div_count == CLK_DIV - 1) begin

                    div_count <= 0;


                    // SCLK currently LOW:
                    // create rising edge and sample MISO
                    if (sclk == 0) begin

                        sclk <= 1;

                        rx_shift <= {
                            rx_shift[6:0],
                            miso
                        };

                    end


                    // SCLK currently HIGH:
                    // create falling edge
                    else begin

                        sclk <= 0;

                        // Finished 8 bits
                        if (bit_count == 7) begin

                            busy    <= 0;
                            cs_n    <= 1;
                            rx_data <= rx_shift;

                            mosi <= 0;

                        end else begin

                            bit_count <= bit_count + 1;

                            tx_shift <= {
                                tx_shift[6:0],
                                1'b0
                            };

                            mosi <= tx_shift[6];

                        end

                    end

                end else begin

                    div_count <= div_count + 1;

                end

            end

        end

    end

endmodule