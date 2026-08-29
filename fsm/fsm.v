//clk, reset, start, stop are wire because this module doesn't procedurally drive them. they're driven by the outside world
module simple_fsm (
    input  wire clk,
    input  wire reset,
    input  wire start,
    input  wire stop,
    output reg  running
);

    reg state;
    reg next_state;

    parameter IDLE = 1'b0;
    parameter RUN  = 1'b1;


    // Sequential: store current state
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end


    // Combinational: calculate next state
    always @(*) begin

        next_state = state;

        case (state)

            IDLE:
                if (start)
                    next_state = RUN;

            RUN:
                if (stop)
                    next_state = IDLE;

            default:
                next_state = IDLE;

        endcase

    end


    // Output logic
    always @(*) begin

        if (state == RUN)
            running = 1'b1;
        else
            running = 1'b0;

    end

endmodule