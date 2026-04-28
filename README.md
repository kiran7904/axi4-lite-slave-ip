# AXI4-Lite Slave Interface IP

This repository contains a compact SystemVerilog AXI4-Lite slave design with a self-checking testbench. The project is intended as a clean RTL portfolio example focused on protocol handshaking, address decoding, byte-lane writes, and simple memory-mapped register access.

## Project Overview

The RTL implements a small AXI4-Lite slave with:

- parameterized address and data widths
- four internal 32-bit registers
- independent read and write channel handshaking
- byte-enable write support through `WSTRB`
- `OKAY` and `SLVERR` response generation

## Repository Contents

- `axi_slave_protocol.sv` : AXI4-Lite slave RTL
- `tb_axi_vip.sv` : self-checking SystemVerilog testbench
- `Makefile` : simple simulation helper for Icarus Verilog
- `.gitignore` : common simulation cleanup rules

## Interface Summary

Write channel:

- `AWADDR`, `AWVALID`, `AWREADY`
- `WDATA`, `WSTRB`, `WVALID`, `WREADY`
- `BRESP`, `BVALID`, `BREADY`

Read channel:

- `ARADDR`, `ARVALID`, `ARREADY`
- `RDATA`, `RRESP`, `RVALID`, `RREADY`

## Verification Coverage

The included testbench checks:

- register write followed by readback
- byte-lane writes using `WSTRB`
- valid read response generation
- invalid address error response behavior

## How to Run

Example with Icarus Verilog:

```bash
make
```

This runs:

```bash
iverilog -g2012 -o axi_slave_sim axi_slave_protocol.sv tb_axi_vip.sv
vvp axi_slave_sim
```

To clean generated files:

```bash
make clean
```
