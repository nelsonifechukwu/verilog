`timescale 1ns/1ps

module demux1to2_tb;

    reg d;
    reg sel;

    wire y0;
    wire y1;

    integer i;

    demux1to2 dut (
        .d(d),
        .sel(sel),
        .y0(y0),
        .y1(y1)
    );

    initial begin
        $display("d sel | y0 y1");
        $display("-------------");

        for (i = 0; i < 4; i = i + 1) begin
            {d, sel} = i[1:0];

            #1;

            if ((y0 !== ((~sel) & d)) ||
                (y1 !== (sel & d))) begin

                $display("FAIL");
                $finish;
            end

            $display("%b  %b  |  %b  %b", d, sel, y0, y1);
        end

        $display("ALL DEMUX TESTS PASSED");
        $finish;
    end

endmodule