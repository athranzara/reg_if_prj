


`timescale 1 ns / 1 ps

`include "arbiter_cpu_regs_defines.v"

module top_module(
input ACLK,
input ARESETN,
input IP_CLK,

output [31:0]     read_AXI_ARADDR,
output            read_AXI_ARREADY,
output            read_AXI_ARVALID,
output [31:0]     read_AXI_AWADDR,
output            read_AXI_AWREADY,
output            read_AXI_AWVALID,
output            read_AXI_BREADY,
output [1:0]      read_AXI_BRESP,
output            read_AXI_BVALID,
output [31:0]     read_AXI_RDATA,
output            read_AXI_RREADY,
output [1:0]      read_AXI_RRESP,
output            read_AXI_RVALID,
output [31:0]     read_AXI_WDATA,
output            read_AXI_WREADY,
output [3:0]      read_AXI_WSTRB,
output            read_AXI_WVALID,

output     [`REG_RO_BITS]    read_ro_reg,
output     [`REG_WO_BITS]    read_wo_reg,
output     [`REG_WOE_BITS]   read_woe_reg,
output     [`REG_ROC_BITS]   read_roc_reg,
output                       read_roc_reg_clear,
output     [`REG_RWS_BITS]   read_rws_reg,
output     [`REG_RWCR_BITS]  read_ip2cpu_rwcr_reg,
output     [`REG_RWCR_BITS]  read_cpu2ip_rwcr_reg,
output                       read_cpu2ip_rwcr_reg_clear,
output     [`REG_RWCW_BITS]  read_ip2cpu_rwcw_reg,
output     [`REG_RWCW_BITS]  read_cpu2ip_rwcw_reg,
output                       read_cpu2ip_rwcw_reg_clear,
output                       read_cpu2ip_rwcw_reg_clear_d,
output     [`REG_RWA_BITS]   read_ip2cpu_rwa_reg,
output     [`REG_RWA_BITS]   read_cpu2ip_rwa_reg
);

    localparam C_S_AXI_DATA_WIDTH    = 32;
    localparam C_S_AXI_ADDR_WIDTH    = 32;



// AXI_LITE ports
    wire [31:0]     inst_AXI_ARADDR;
    wire            inst_AXI_ARREADY;
    wire            inst_AXI_ARVALID;
    wire [31:0]     inst_AXI_AWADDR;
    wire            inst_AXI_AWREADY;
    wire            inst_AXI_AWVALID;
    wire            inst_AXI_BREADY;
    wire [1:0]      inst_AXI_BRESP;
    wire            inst_AXI_BVALID;
    wire [31:0]     inst_AXI_RDATA;
    wire            inst_AXI_RREADY;
    wire [1:0]      inst_AXI_RRESP;
    wire            inst_AXI_RVALID;
    wire [31:0]     inst_AXI_WDATA;
    wire            inst_AXI_WREADY;
    wire [3:0]      inst_AXI_WSTRB;
    wire            inst_AXI_WVALID;

    reg      [`REG_RO_BITS]     ro_reg;
    wire     [`REG_WO_BITS]     wo_reg;
    wire     [`REG_WOE_BITS]    woe_reg;
    reg      [`REG_ROC_BITS]    roc_reg;
    wire                        roc_reg_clear;
    wire     [`REG_RWS_BITS]    rws_reg;
    reg      [`REG_RWCR_BITS]   ip2cpu_rwcr_reg;
    wire     [`REG_RWCR_BITS]   cpu2ip_rwcr_reg;
    wire                        cpu2ip_rwcr_reg_clear;
    reg      [`REG_RWCW_BITS]   ip2cpu_rwcw_reg;
    wire     [`REG_RWCW_BITS]   cpu2ip_rwcw_reg;
    wire                        cpu2ip_rwcw_reg_clear;
    wire                        cpu2ip_rwcw_reg_clear_d;
    reg      [`REG_RWA_BITS]    ip2cpu_rwa_reg;
    wire     [`REG_RWA_BITS]    cpu2ip_rwa_reg;


    wire axi_aclk;
    wire axi_resetn;
    wire resetn_sync;
    
assign read_AXI_ARADDR = inst_AXI_ARADDR;
assign read_AXI_ARREADY = inst_AXI_ARREADY;
assign read_AXI_ARVALID = inst_AXI_ARVALID;
assign read_AXI_AWADDR = inst_AXI_AWADDR;
assign read_AXI_AWREADY = inst_AXI_AWREADY;
assign read_AXI_AWVALID = inst_AXI_AWVALID;
assign read_AXI_BREADY = inst_AXI_BREADY;
assign read_AXI_BRESP = inst_AXI_BRESP;
assign read_AXI_BVALID = inst_AXI_BVALID;
assign read_AXI_RDATA = inst_AXI_RDATA;
assign read_AXI_RREADY = inst_AXI_RREADY;
assign read_AXI_RRESP = inst_AXI_RRESP;
assign read_AXI_RVALID = inst_AXI_RVALID;
assign read_AXI_WDATA = inst_AXI_WDATA;
assign read_AXI_WREADY = inst_AXI_WREADY;
assign read_AXI_WSTRB = inst_AXI_WSTRB;
assign read_AXI_WVALID = inst_AXI_WVALID;


assign read_ro_reg = ro_reg;
assign read_wo_reg = wo_reg;
assign read_woe_reg = woe_reg;
assign read_roc_reg = roc_reg;
assign read_roc_reg_clear = roc_reg_clear;
assign read_rws_reg = rws_reg;
assign read_ip2cpu_rwcr_reg = ip2cpu_rwcr_reg;
assign read_cpu2ip_rwcr_reg = cpu2ip_rwcr_reg;
assign read_cpu2ip_rwcr_reg_clear = cpu2ip_rwcr_reg_clear;
assign read_ip2cpu_rwcw_reg = ip2cpu_rwcw_reg;
assign read_cpu2ip_rwcw_reg = cpu2ip_rwcw_reg;
assign read_cpu2ip_rwcw_reg_clear = cpu2ip_rwcw_reg_clear;
assign read_cpu2ip_rwcw_reg_clear_d = cpu2ip_rwcw_reg_clear_d;
assign read_ip2cpu_rwa_reg = ip2cpu_rwa_reg;
assign read_cpu2ip_rwa_reg = cpu2ip_rwa_reg;


assign axi_aclk = IP_CLK;
assign axi_resetn = ARESETN;
    
// master pattern generater
axi_lite_master axi_lite_master_inst
    (.M_AXI_ACLK    (ACLK),
    .M_AXI_ARADDR   (inst_AXI_ARADDR),
    .M_AXI_ARESETN  (ARESETN),
    .M_AXI_ARREADY  (inst_AXI_ARREADY),
    .M_AXI_ARVALID  (inst_AXI_ARVALID),
    .M_AXI_AWADDR   (inst_AXI_AWADDR),
    .M_AXI_AWREADY  (inst_AXI_AWREADY),
    .M_AXI_AWVALID  (inst_AXI_AWVALID),
    .M_AXI_BREADY   (inst_AXI_BREADY),
    .M_AXI_BRESP    (inst_AXI_BRESP),
    .M_AXI_BVALID   (inst_AXI_BVALID),
    .M_AXI_RDATA    (inst_AXI_RDATA),
    .M_AXI_RREADY   (inst_AXI_RREADY),
    .M_AXI_RRESP    (inst_AXI_RRESP),
    .M_AXI_RVALID   (inst_AXI_RVALID),
    .M_AXI_WDATA    (inst_AXI_WDATA),
    .M_AXI_WREADY   (inst_AXI_WREADY),
    .M_AXI_WSTRB    (inst_AXI_WSTRB),
    .M_AXI_WVALID   (inst_AXI_WVALID)
    );

//Registers section
 arbiter_cpu_regs 
 #(
     .C_S_AXI_DATA_WIDTH    (C_S_AXI_DATA_WIDTH),
     .C_S_AXI_ADDR_WIDTH    (C_S_AXI_ADDR_WIDTH)
 ) cpu_regs_inst
 (   
   // General ports
    .clk                    (axi_aclk),
    .resetn                 (axi_resetn),
   // AXI Lite ports
    .S_AXI_ACLK             (ACLK),
    .S_AXI_ARESETN          (ARESETN),
    .S_AXI_AWADDR           (inst_AXI_AWADDR),
    .S_AXI_AWVALID          (inst_AXI_AWVALID),
    .S_AXI_WDATA            (inst_AXI_WDATA),
    .S_AXI_WSTRB            (inst_AXI_WSTRB),
    .S_AXI_WVALID           (inst_AXI_WVALID),
    .S_AXI_BREADY           (inst_AXI_BREADY),
    .S_AXI_ARADDR           (inst_AXI_ARADDR),
    .S_AXI_ARVALID          (inst_AXI_ARVALID),
    .S_AXI_RREADY           (inst_AXI_RREADY),
    .S_AXI_ARREADY          (inst_AXI_ARREADY),
    .S_AXI_RDATA            (inst_AXI_RDATA),
    .S_AXI_RRESP            (inst_AXI_RRESP),
    .S_AXI_RVALID           (inst_AXI_RVALID),
    .S_AXI_WREADY           (inst_AXI_WREADY),
    .S_AXI_BRESP            (inst_AXI_BRESP),
    .S_AXI_BVALID           (inst_AXI_BVALID),
    .S_AXI_AWREADY          (inst_AXI_AWREADY),
   
   // Register ports
   .ro_reg          (ro_reg),
   .wo_reg          (wo_reg),
   .woe_reg          (woe_reg),
   .roc_reg          (roc_reg),
   .roc_reg_clear    (roc_reg_clear),
   .rws_reg          (rws_reg),
   .ip2cpu_rwcr_reg          (ip2cpu_rwcr_reg),
   .cpu2ip_rwcr_reg          (cpu2ip_rwcr_reg),
   .cpu2ip_rwcr_reg_clear    (cpu2ip_rwcr_reg_clear),
   .ip2cpu_rwcw_reg          (ip2cpu_rwcw_reg),
   .cpu2ip_rwcw_reg          (cpu2ip_rwcw_reg),
   .cpu2ip_rwcw_reg_clear    (cpu2ip_rwcw_reg_clear),
   .ip2cpu_rwa_reg          (ip2cpu_rwa_reg),
   .cpu2ip_rwa_reg          (cpu2ip_rwa_reg),
   // Global Registers - user can select if to use
   .cpu_resetn_soft(),//software reset, after cpu module
   .resetn_soft    (),//software reset to cpu module (from central reset management)
   .resetn_sync    (resetn_sync)//synchronized reset, use for better timing
);











reg cpu_rwcw_reg_clear_d;

always @(posedge axi_aclk)
	if (~resetn_sync) begin
		ro_reg <=                 `REG_RO_DEFAULT;
		roc_reg <=                `REG_ROC_DEFAULT;
		ip2cpu_rwcr_reg <=        `REG_RWCR_DEFAULT;
		ip2cpu_rwcw_reg <=        `REG_RWCW_DEFAULT;
		cpu_rwcw_reg_clear_d <=   'h0;
		ip2cpu_rwa_reg <=         `REG_RWA_DEFAULT;
	end
	else begin
		ro_reg <=     `REG_RO_DEFAULT;
		roc_reg <=   roc_reg_clear ? 'h0  : `REG_ROC_DEFAULT;
		ip2cpu_rwcr_reg <=   cpu2ip_rwcr_reg_clear ? 'h0  : `REG_RWCR_DEFAULT;
		ip2cpu_rwcw_reg <=   cpu_rwcw_reg_clear_d ? 'h0  :    `REG_RWCW_DEFAULT;
		cpu_rwcw_reg_clear_d <=     cpu2ip_rwcw_reg_clear;
		ip2cpu_rwa_reg <=     `REG_RWA_DEFAULT;
        end













endmodule
