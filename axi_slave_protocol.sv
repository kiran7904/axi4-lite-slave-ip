`timescale 1ns / 1ps

// -----------------------------------------------------------------------------
// AXI4-Lite Slave Interface
// -----------------------------------------------------------------------------
// A compact register-mapped AXI4-Lite slave with:
// - 4 internal word registers
// - byte-enable writes using WSTRB
// - simple OKAY / SLVERR response generation
//
// This module is intentionally small and readable as a portfolio RTL sample.
// -----------------------------------------------------------------------------

module axi_slave_protocol #(
    parameter addr_width = 4,
    parameter data_width = 32
)(
    input  logic clk,
    input  logic rst_n,

    input  logic [addr_width-1:0] awaddr,
    input  logic awvalid,
    output logic awready,

    input  logic [data_width-1:0] wdata,
    input  logic [(data_width/8)-1:0] wstrb,
    input  logic wvalid,
    output logic wready,

    output logic bvalid,
    input  logic bready,
    output logic [1:0] bresp,

    input  logic [addr_width-1:0] araddr,
    input  logic arvalid,
    output logic arready,

    output logic [data_width-1:0] rdata,
    output logic rvalid,
    input  logic rready,
    output logic [1:0] rresp
);

    localparam int REG_COUNT = 4;
    localparam logic [1:0] AXI_RESP_OKAY   = 2'b00;
    localparam logic [1:0] AXI_RESP_SLVERR = 2'b10;

    logic [data_width-1:0] regfile [0:REG_COUNT-1];

    logic aw_hs, w_hs, ar_hs;
    logic aw_pending, w_pending;
    logic [addr_width-1:0] awaddr_q;
    logic [addr_width-1:0] write_index_s;
    logic [addr_width-1:0] read_index_s;
    logic                  write_addr_valid_s;
    logic                  read_addr_valid_s;

    assign awready = !aw_pending;
    assign wready  = !w_pending;
    assign arready = !rvalid;

    assign aw_hs = awvalid && awready;
    assign w_hs  = wvalid  && wready;
    assign ar_hs = arvalid && arready;

    assign write_index_s      = awaddr_q[3:2];
    assign read_index_s       = araddr[3:2];
    assign write_addr_valid_s = (write_index_s < REG_COUNT);
    assign read_addr_valid_s  = (read_index_s < REG_COUNT);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            aw_pending <= 0;
            w_pending  <= 0;
            bvalid     <= 0;
            bresp      <= 0;
            rvalid     <= 0;
            rresp      <= 0;
            rdata      <= 0;
            awaddr_q   <= 0;
            for (int i = 0; i < REG_COUNT; i++) regfile[i] <= 0;
        end else begin
            if (aw_hs) begin
                awaddr_q   <= awaddr;
                aw_pending <= 1;
            end

            if (w_hs) begin
                w_pending <= 1;
            end

            if (aw_pending && w_pending && !bvalid) begin
                if (write_addr_valid_s) begin
                    for (int i = 0; i < data_width/8; i++)
                        if (wstrb[i])
                            regfile[write_index_s][8*i +: 8] <= wdata[8*i +: 8];
                    bresp <= AXI_RESP_OKAY;
                end else begin
                    bresp <= AXI_RESP_SLVERR;
                end
                bvalid     <= 1;
                aw_pending <= 0;
                w_pending  <= 0;
            end

            if (bvalid && bready)
                bvalid <= 0;

            if (ar_hs) begin
                if (read_addr_valid_s) begin
                    rdata <= regfile[read_index_s];
                    rresp <= AXI_RESP_OKAY;
                end else begin
                    rdata <= 0;
                    rresp <= AXI_RESP_SLVERR;
                end
                rvalid <= 1;
            end

            if (rvalid && rready)
                rvalid <= 0;
        end
    end

endmodule
