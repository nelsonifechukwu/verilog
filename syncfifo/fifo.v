module fifo(
    input wire clk, reset,
    input wire w_en, r_en,
    input wire [7:0] w_data,
    output reg r_data,
    output wire empty, full
);

    reg [7:0] mem [0:4];
    /* 
    memory
            ┌───────┐
    index 0 │ A(8'b)│ ← read_ptr
            ├───────┤
    index 1 │ B     │
            ├───────┤
    index 2 │ C     │
            ├───────┤
    index 3 │       │ ← write_ptr
            └───────┘
    */

    reg [1:0] w_ptr;
    reg [1:0] r_ptr;
    reg [2:0] count; //count must represent 0...4 (5 values), so we need more bits as 2 bits only allow us to represent 4 values.

    assign empty = (count == 0);
    assign full  = (count == 4);

    always @(posedge clk) begin

        if (reset) begin //cause multiple statements are being controlled
            w_ptr  <= 0;
            r_ptr  <= 0;
            count   <= 0;
            r_data <= 0;

        end else begin
            //write
            if (w_en && !full) begin
                mem[w_ptr] <= w_data;
                w_ptr <= w_ptr + 1;
                count <= count + 1;
            end

            //read
            if (r_en && !empty) begin
                r_data <= mem[r_ptr];
                r_ptr <= r_ptr + 1;
                count <= count - 1;
            end 

            //update count
            case


            endcase
        end 
    end
endmodule