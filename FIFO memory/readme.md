 Synchronous FIFO Memory using Verilog

A parameterized synchronous FIFO (First-In First-Out) memory implemented
using Verilog HDL.

Overview

FIFO memory is commonly used for buffering data between different
modules or processing stages.

The first data written into the FIFO is the first data read out.

Features

- Synchronous FIFO
- Parameterized data width
- Parameterized FIFO depth
- Write enable
- Read enable
- Full flag
- Empty flag
- Occupancy counter
- Circular read/write pointers
- Verilog testbench


 Block Diagram

```text
             +-------------------+
             |                   |
DIN -------->|                   |
WR_EN ------>|    FIFO MEMORY    |-----> DOUT
RD_EN ------>|                   |
             |                   |
             +-------------------+
                |      |      |
|                   
                   FULL   EMPTY  COUNTOUT
