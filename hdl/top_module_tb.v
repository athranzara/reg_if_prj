`timescale 1 ns / 1 ps

`include "arbiter_cpu_regs_defines.v"

module top_module_tb();

reg ACLK;
reg ARESETN;
reg IP_CLK;

wire [31:0]     read_AXI_ARADDR;
wire            read_AXI_ARREADY;
wire            read_AXI_ARVALID;
wire [31:0]     read_AXI_AWADDR;
wire            read_AXI_AWREADY;
wire            read_AXI_AWVALID;
wire            read_AXI_BREADY;
wire [1:0]      read_AXI_BRESP;
wire            read_AXI_BVALID;
wire [31:0]     read_AXI_RDATA;
wire            read_AXI_RREADY;
wire [1:0]      read_AXI_RRESP;
wire            read_AXI_RVALID;
wire [31:0]     read_AXI_WDATA;
wire            read_AXI_WREADY;
wire [3:0]      read_AXI_WSTRB;
wire            read_AXI_WVALID;

wire     [`REG_RO_BITS]    read_ro_reg;
wire     [`REG_WO_BITS]    read_wo_reg;
wire     [`REG_WOE_BITS]   read_woe_reg;
wire     [`REG_ROC_BITS]   read_roc_reg;
wire                       read_roc_reg_clear;
wire     [`REG_RWS_BITS]   read_rws_reg;
wire     [`REG_RWCR_BITS]  read_ip2cpu_rwcr_reg;
wire     [`REG_RWCR_BITS]  read_cpu2ip_rwcr_reg;
wire                       read_cpu2ip_rwcr_reg_clear;
wire     [`REG_RWCW_BITS]  read_ip2cpu_rwcw_reg;
wire     [`REG_RWCW_BITS]  read_cpu2ip_rwcw_reg;
wire                       read_cpu2ip_rwcw_reg_clear;
wire                       read_cpu2ip_rwcw_reg_clear_d;
wire     [`REG_RWA_BITS]   read_ip2cpu_rwa_reg;
wire     [`REG_RWA_BITS]   read_cpu2ip_rwa_reg;

top_module top_module_inst(
    .ACLK(ACLK),
    .ARESETN(ARESETN),
    .IP_CLK(IP_CLK),
    .read_AXI_ARADDR(read_AXI_ARADDR),
    .read_AXI_ARREADY(read_AXI_ARREADY),
    .read_AXI_ARVALID(read_AXI_ARVALID),
    .read_AXI_AWADDR(read_AXI_AWADDR),
    .read_AXI_AWREADY(read_AXI_AWREADY),
    .read_AXI_AWVALID(read_AXI_AWVALID),
    .read_AXI_BREADY(read_AXI_BREADY),
    .read_AXI_BRESP(read_AXI_BRESP),
    .read_AXI_BVALID(read_AXI_BVALID),
    .read_AXI_RDATA(read_AXI_RDATA),
    .read_AXI_RREADY(read_AXI_RREADY),
    .read_AXI_RRESP(read_AXI_RRESP),
    .read_AXI_RVALID(read_AXI_RVALID),
    .read_AXI_WDATA(read_AXI_WDATA),
    .read_AXI_WREADY(read_AXI_WREADY),
    .read_AXI_WSTRB(read_AXI_WSTRB),
    .read_AXI_WVALID(read_AXI_WVALID),

    .read_ro_reg(read_ro_reg),
    .read_wo_reg(read_wo_reg),
    .read_woe_reg(read_woe_reg),
    .read_roc_reg(read_roc_reg),
    .read_roc_reg_clear(read_roc_reg_clear),
    .read_rws_reg(read_rws_reg),
    .read_ip2cpu_rwcr_reg(read_ip2cpu_rwcr_reg),
    .read_cpu2ip_rwcr_reg(read_cpu2ip_rwcr_reg),
    .read_cpu2ip_rwcr_reg_clear(read_cpu2ip_rwcr_reg_clear),
    .read_ip2cpu_rwcw_reg(read_ip2cpu_rwcw_reg),
    .read_cpu2ip_rwcw_reg(read_cpu2ip_rwcw_reg),
    .read_cpu2ip_rwcw_reg_clear(read_cpu2ip_rwcw_reg_clear),
    .read_cpu2ip_rwcw_reg_clear_d(read_cpu2ip_rwcw_reg_clear_d),
    .read_ip2cpu_rwa_reg(read_ip2cpu_rwa_reg),
    .read_cpu2ip_rwa_reg(read_cpu2ip_rwa_reg)
);

// clock generation

initial begin
  ACLK = 1'b0;
  forever begin
    ACLK = #3.125 ~ACLK;
  end
end

initial begin
  IP_CLK = 1'b0;
  forever begin
    IP_CLK = #5 ~ACLK;
  end
end

initial begin
  ARESETN = 1'b0;
  repeat (16) @(posedge ACLK);
  ;
  ARESETN = 1'b1;
//  repeat (300) @(posedge ACLK);
//  $finish;
end

endmodule
