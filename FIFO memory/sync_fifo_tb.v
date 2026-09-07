`timescale 1ns/1ps

module sync_fifo_tb;

    parameter DATA_WIDTH = 8;
    parameter FIFO_DEPTH = 16;

    reg clk;
    reg reset;

    reg wr_en;
    reg rd_en;

    reg [DATA_WIDTH-1:0] din;

    wire [DATA_WIDTH-1:0] dout;
    wire full;
    wire empty;

    wire [4:0] count;

    // ------------------------------------------------
    // Device Under Test
    // ------------------------------------------------

    sync_fifo #(
        .DATA_WIDTH(8),
        .FIFO_DEPTH(16),
        .ADDR_WIDTH(4)
    ) dut (

        .clk(clk),
        .reset(reset),

        .wr_en(wr_en),
        .din(din),

        .rd_en(rd_en),
        .dout(dout),

        .full(full),
        .empty(empty),

        .count(count)
    );

    // ------------------------------------------------
    // Clock
    // ------------------------------------------------

    initial begin

        clk = 1'b0;

        forever #5 clk = ~clk;

    end

    // ------------------------------------------------
    // Write task
    // ------------------------------------------------

    task write_data(input [7:0] data);

        begin

            @(negedge clk);

            din   = data;
            wr_en = 1'b1;

            @(negedge clk);

            wr_en = 1'b0;

        end

    endtask

    // ------------------------------------------------
    // Read task
    // ------------------------------------------------

    task read_data;

        begin

            @(negedge clk);

            rd_en = 1'b1;

            @(negedge clk);

            rd_en = 1'b0;

            $display(
                "Time=%0t | Read Data = %h | Count = %d",
                $time,
                dout,
                count
            );

        end

    endtask

    // ------------------------------------------------
    // Testbench
    // ------------------------------------------------

    initial begin

        // Initial values

        reset = 1'b1;
        wr_en = 1'b0;
        rd_en = 1'b0;
        din   = 8'h00;

        #20;

        reset = 1'b0;

        // ============================================
        // TEST 1: Write data
        // ============================================

        $display("----------------------------------");
        $display("TEST 1: WRITE DATA");
        $display("----------------------------------");

        write_data(8'h11);
        write_data(8'h22);
        write_data(8'h33);
        write_data(8'h44);

        $display("FIFO Count = %d", count);

        // ============================================
        // TEST 2: Read data
        // ============================================

        $display("----------------------------------");
        $display("TEST 2: READ DATA");
        $display("----------------------------------");

        read_data;
        read_data;
        read_data;
        read_data;

        // ============================================
        // TEST 3: Empty FIFO
        // ============================================

        $display("----------------------------------");
        $display("TEST 3: EMPTY FIFO");
        $display("----------------------------------");

        $display("Empty = %b", empty);
        $display("Count = %d", count);

        // ============================================
        // TEST 4: Multiple writes
        // ============================================

        $display("----------------------------------");
        $display("TEST 4: MULTIPLE WRITES");
        $display("----------------------------------");

        write_data(8'hAA);
        write_data(8'hBB);
        write_data(8'hCC);

        $display("Count = %d", count);

        // ============================================
        // TEST 5: Read after write
        // ============================================

        $display("----------------------------------");
        $display("TEST 5: READ AFTER WRITE");
        $display("----------------------------------");

        read_data;
        read_data;
        read_data;

        // ============================================
        // Finish
        // ============================================

        $display("----------------------------------");
        $display("SIMULATION COMPLETED");
        $display("----------------------------------");

        #20;

        $finish;

    end

    // ------------------------------------------------
    // Monitor
    // ------------------------------------------------

    initial begin

        $monitor(
            "Time=%0t | WR=%b | RD=%b | DIN=%h | DOUT=%h | FULL=%b | EMPTY=%b | COUNT=%d",
            $time,
            wr_en,
            rd_en,
            din,
            dout,
            full,
            empty,
            count
        );

    end

endmodule
