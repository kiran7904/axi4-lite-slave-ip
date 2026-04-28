# AXI4-Lite Slave Interface IP

> A compact SystemVerilog AXI4-Lite slave with read/write channel handling, byte-enable support, and a self-checking verification testbench.

## Why This Project

This project is a focused RTL design sample built to demonstrate practical bus-interface design skills such as handshake handling, address decoding, response generation, and register-mapped data movement.

It is intended as a strong portfolio project for:

- RTL design roles
- SoC integration internships
- AMBA / bus-protocol interview discussions
- FPGA and digital verification profiles

## Design Snapshot

| Item | Value |
|------|-------|
| Language | SystemVerilog |
| Protocol | AXI4-Lite |
| Register model | 4 x 32-bit internal registers |
| Write support | `WSTRB` byte enables |
| Verification | Self-checking testbench |

## Core Features

- parameterized address and data widths
- independent AXI4-Lite read and write channel handling
- internal register-file storage
- byte-lane write updates through `WSTRB`
- `OKAY` response for valid access
- `SLVERR` response for invalid address access

## File Structure

| File | Purpose |
|------|---------|
| `axi_slave_protocol.sv` | Main AXI4-Lite slave RTL |
| `tb_axi_vip.sv` | Functional testbench with protocol checks |
| `Makefile` | Simple simulation flow using Icarus Verilog |
| `.gitignore` | Common generated-file cleanup rules |

## Interface Summary

### Write Channel

- `AWADDR`, `AWVALID`, `AWREADY`
- `WDATA`, `WSTRB`, `WVALID`, `WREADY`
- `BRESP`, `BVALID`, `BREADY`

### Read Channel

- `ARADDR`, `ARVALID`, `ARREADY`
- `RDATA`, `RRESP`, `RVALID`, `RREADY`

## Verification Scope

The testbench checks:

- full-word write and readback
- byte-enable write behavior using `WSTRB`
- valid register access response generation
- invalid address `SLVERR` behavior
- final pass/fail summary output

## Quick Start

Run simulation with:

```bash
make
```

Equivalent manual flow:

```bash
iverilog -g2012 -o axi_slave_sim axi_slave_protocol.sv tb_axi_vip.sv
vvp axi_slave_sim
```

Clean generated files:

```bash
make clean
```

## What This Shows

This repository highlights practical experience with:

- AMBA-style protocol handshaking
- memory-mapped register design
- synthesizable control-path RTL
- self-checking verification flow

## Notes

This standalone repository was separated from a larger practice collection and cleaned up for independent technical review.
