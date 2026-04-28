`timescale 1ns / 1ps

module tb_axi_vip;

    logic clk, rst_n;

    logic [3:0] awaddr, araddr;
    logic awvalid, awready;
    logic wvalid, wready;
    logic [31:0] wdata, rdata;
    logic [3:0] wstrb;
    logic bvalid, bready;
    logic rvalid, rready;
    logic [1:0] bresp, rresp;
    integer error_count;

    axi_slave_protocol dut (.*);

    initial clk = 0;
    always #5 clk = ~clk;

    task axi_write(input [3:0] addr, input [31:0] data);
        awaddr  <= addr;
        awvalid <= 1;
        wait (awready);
        @(posedge clk);
        awvalid <= 0;

        wdata   <= data;
        wstrb   <= 4'hF;
        wvalid  <= 1;
        wait (wready);
        @(posedge clk);
        wvalid <= 0;

        bready <= 1;
        wait (bvalid);
        @(posedge clk);
        bready <= 0;
    endtask

    task axi_read(input [3:0] addr);
        araddr  <= addr;
        arvalid <= 1;
        wait (arready);
        @(posedge clk);
        arvalid <= 0;

        rready <= 1;
        wait (rvalid);
        @(posedge clk);
        rready <= 0;
    endtask

    task check_equal(input [31:0] got, input [31:0] exp, input [255:0] msg);
        begin
            if (got !== exp) begin
                $display("FAIL: %0s | got=%h expected=%h", msg, got, exp);
                error_count = error_count + 1;
            end else begin
                $display("PASS: %0s | value=%h", msg, got);
            end
        end
    endtask

    initial begin
        $dumpfile("tb_axi_vip.vcd");
        $dumpvars(0, tb_axi_vip);

        rst_n = 0;
        awvalid = 0;
        wvalid  = 0;
        arvalid = 0;
        bready  = 0;
        rready  = 0;
        wstrb   = 0;
        error_count = 0;
        #20 rst_n = 1;

        axi_write(4'h0, 32'hDEADBEEF);
        axi_read(4'h0);
        check_equal(rdata, 32'hDEADBEEF, "Full-word write/readback");

        axi_write(4'hC, 32'hCAFEBABE);
        axi_read(4'hC);
        check_equal(rdata, 32'hCAFEBABE, "Upper register write/readback");

        awaddr  <= 4'h4;
        awvalid <= 1;
        wait (awready);
        @(posedge clk);
        awvalid <= 0;
        wdata   <= 32'h12345678;
        wstrb   <= 4'b0011;
        wvalid  <= 1;
        wait (wready);
        @(posedge clk);
        wvalid <= 0;
        bready <= 1;
        wait (bvalid);
        @(posedge clk);
        bready <= 0;
        axi_read(4'h4);
        check_equal(rdata, 32'h00005678, "Byte-enable write using WSTRB");

        axi_read(4'hF);
        if (rresp !== 2'b10) begin
            $display("FAIL: Invalid address did not return SLVERR");
            error_count = error_count + 1;
        end else begin
            $display("PASS: Invalid address returned SLVERR");
        end

        if (error_count == 0)
            $display("TEST PASSED: AXI4-Lite slave checks completed successfully.");
        else
            $display("TEST FAILED: error_count=%0d", error_count);

        #100 $finish;
    end

endmodule
