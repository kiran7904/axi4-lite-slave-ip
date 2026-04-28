# AXI4-Lite Slave Interface IP

This repository contains a simple parameterized AXI4-Lite slave interface RTL design and a companion SystemVerilog testbench.

## Files

- `axi_slave_protocol.sv` : AXI4-Lite slave RTL
- `tb_axi_vip.sv` : basic testbench for read/write validation

## Features

- Parameterized address and data width
- Separate read and write channel handling
- Register-file based storage
- Byte-enable write support through `WSTRB`
- Basic error response for invalid address access

## How to Run

You can simulate this design with any SystemVerilog-capable simulator.

Example with `iverilog`:

```bash
iverilog -g2012 -o axi_slave_sim axi_slave_protocol.sv tb_axi_vip.sv
vvp axi_slave_sim
```

## Notes

This project was originally maintained as a folder inside a larger practice repository and has been split into its own standalone repository for portfolio and resume use.
