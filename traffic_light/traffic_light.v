//is an FSM

module traffic_light (
    input  wire clk,
    input  wire reset,
    input  wire timer_done,

    output reg green,
    output reg yellow,
    output reg red
);

    reg [1:0] state;
    reg [1:0] next_state;

    parameter GREEN  = 2'b00;
    parameter YELLOW = 2'b01;
    parameter RED    = 2'b10;


    // 1. State register: sequential
    always @(posedge clk) begin
        if (reset)
            state <= RED;
        else
            state <= next_state;
    end


    // 2. Next-state logic: combinational
    always @(*) begin

        next_state = state;

        case (state)

            GREEN:
                if (timer_done)
                    next_state = YELLOW;

            YELLOW:
                if (timer_done)
                    next_state = RED;

            RED:
                if (timer_done)
                    next_state = GREEN;

            default:
                next_state = RED;

        endcase
    end


    // 3. Output logic: combinational
    always @(*) begin

        green  = 1'b0;
        yellow = 1'b0;
        red    = 1'b0;

        case (state)

            GREEN:
                green = 1'b1;

            YELLOW:
                yellow = 1'b1;

            RED:
                red = 1'b1;

            default:
                red = 1'b1;

        endcase
    end

endmodule