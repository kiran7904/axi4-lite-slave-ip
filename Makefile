SIM ?= iverilog
RUN ?= vvp
TOP ?= tb_axi_vip
OUT ?= axi_slave_sim

all: run

build:
	$(SIM) -g2012 -o $(OUT) axi_slave_protocol.sv tb_axi_vip.sv

run: build
	$(RUN) $(OUT)

clean:
	del /q $(OUT) *.vcd 2>nul || rm -f $(OUT) *.vcd

.PHONY: all build run clean
