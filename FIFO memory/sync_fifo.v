`timescale 1ns/1ps

module sync_fifo #(
    parameter DATA_WIDTH = 8,
    parameter FIFO_DEPTH = 16,
    parameter ADDR_WIDTH = 4
)(
    input  wire                  clk,
    input  wire                  reset,

    // Write interface
    input  wire                  wr_en,
    input  wire [DATA_WIDTH-1:0] din,

    // Read interface
    input  wire                  rd_en,
    output reg  [DATA_WIDTH-1:0] dout,

    // Status
    output wire                  full,
    output wire                  empty,
    output reg  [ADDR_WIDTH:0]   count
);

    // FIFO memory
    reg [DATA_WIDTH-1:0] mem [0:FIFO_DEPTH-1];

    // Read and write pointers
    reg [ADDR_WIDTH-1:0] wr_ptr;
    reg [ADDR_WIDTH-1:0] rd_ptr;

    // ------------------------------------------------
    // Status flags
    // ------------------------------------------------

    assign empty = (count == 0);
    assign full  = (count == FIFO_DEPTH);

    // ------------------------------------------------
    // FIFO operation
    // ------------------------------------------------

    always @(posedge clk or posedge reset) begin

        if (reset) begin

            wr_ptr <= 0;
            rd_ptr <= 0;
            count  <= 0;
            dout   <= 0;

        end

        else begin

            // ----------------------------------------
            // Write operation
            // ----------------------------------------

            if (wr_en && !full) begin

                mem[wr_ptr] <= din;

                if (wr_ptr == FIFO_DEPTH-1)
                    wr_ptr <= 0;
                else
                    wr_ptr <= wr_ptr + 1'b1;

            end

            // ----------------------------------------
            // Read operation
            // ----------------------------------------

            if (rd_en && !empty) begin

                dout <= mem[rd_ptr];

                if (rd_ptr == FIFO_DEPTH-1)
                    rd_ptr <= 0;
                else
                    rd_ptr <= rd_ptr + 1'b1;

            end

            // ----------------------------------------
            // Count update
            // ----------------------------------------

            case ({wr_en && !full, rd_en && !empty})

                2'b10: count <= count + 1'b1;

                2'b01: count <= count - 1'b1;

                default: count <= count;

            endcase

        end

    end

endmodule
