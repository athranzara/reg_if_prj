`uselib lib=proc_common_v3_00_a
`include "arbiter_cpu_regs_defines.v"

//parameters to be added to the top module parameters
#(
    // AXI Registers Data Width
    parameter C_S_AXI_DATA_WIDTH    = 32,
    parameter C_S_AXI_ADDR_WIDTH    = 32
)
//ports to be added to the top module ports
(
// Signals for AXI_IP and IF_REG (Added for debug purposes)
    // Slave AXI Ports
    input                                     S_AXI_ACLK,
    input                                     S_AXI_ARESETN,
    input      [C_S_AXI_ADDR_WIDTH-1 : 0]     S_AXI_AWADDR,
    input                                     S_AXI_AWVALID,
    input      [C_S_AXI_DATA_WIDTH-1 : 0]     S_AXI_WDATA,
    input      [C_S_AXI_DATA_WIDTH/8-1 : 0]   S_AXI_WSTRB,
    input                                     S_AXI_WVALID,
    input                                     S_AXI_BREADY,
    input      [C_S_AXI_ADDR_WIDTH-1 : 0]     S_AXI_ARADDR,
    input                                     S_AXI_ARVALID,
    input                                     S_AXI_RREADY,
    output                                    S_AXI_ARREADY,
    output     [C_S_AXI_DATA_WIDTH-1 : 0]     S_AXI_RDATA,
    output     [1 : 0]                        S_AXI_RRESP,
    output                                    S_AXI_RVALID,
    output                                    S_AXI_WREADY,
    output     [1 :0]                         S_AXI_BRESP,
    output                                    S_AXI_BVALID,
    output                                    S_AXI_AWREADY
)

    reg      [`REG_RO_BITS]    ro_reg;
    wire     [`REG_WO_BITS]    wo_reg;
    wire     [`REG_WOE_BITS]    woe_reg;
    reg      [`REG_ROC_BITS]    roc_reg;
    wire                             roc_reg_clear;
    wire     [`REG_RWS_BITS]    rws_reg;
    reg      [`REG_RWCR_BITS]    ip2cpu_rwcr_reg;
    wire     [`REG_RWCR_BITS]    cpu2ip_rwcr_reg;
    wire                             cpu2ip_rwcr_reg_clear;
    reg      [`REG_RWCW_BITS]    ip2cpu_rwcw_reg;
    wire     [`REG_RWCW_BITS]    cpu2ip_rwcw_reg;
    wire                             cpu2ip_rwcw_reg_clear;
    wire                             cpu2ip_rwcw_reg_clear_d;
    reg      [`REG_RWA_BITS]    ip2cpu_rwa_reg;
    wire     [`REG_RWA_BITS]    cpu2ip_rwa_reg;

//Registers section
 arbiter_cpu_regs 
 #(
     .C_BASE_ADDRESS        (C_BASEADDR ),
     .C_S_AXI_DATA_WIDTH    (C_S_AXI_DATA_WIDTH),
     .C_S_AXI_ADDR_WIDTH    (C_S_AXI_ADDR_WIDTH)
 ) arbiter_cpu_regs_inst
 (   
   // General ports
    .clk                    (axi_aclk),
    .resetn                 (axi_resetn),
   // AXI Lite ports
    .S_AXI_ACLK             (S_AXI_ACLK),
    .S_AXI_ARESETN          (S_AXI_ARESETN),
    .S_AXI_AWADDR           (S_AXI_AWADDR),
    .S_AXI_AWVALID          (S_AXI_AWVALID),
    .S_AXI_WDATA            (S_AXI_WDATA),
    .S_AXI_WSTRB            (S_AXI_WSTRB),
    .S_AXI_WVALID           (S_AXI_WVALID),
    .S_AXI_BREADY           (S_AXI_BREADY),
    .S_AXI_ARADDR           (S_AXI_ARADDR),
    .S_AXI_ARVALID          (S_AXI_ARVALID),
    .S_AXI_RREADY           (S_AXI_RREADY),
    .S_AXI_ARREADY          (S_AXI_ARREADY),
    .S_AXI_RDATA            (S_AXI_RDATA),
    .S_AXI_RRESP            (S_AXI_RRESP),
    .S_AXI_RVALID           (S_AXI_RVALID),
    .S_AXI_WREADY           (S_AXI_WREADY),
    .S_AXI_BRESP            (S_AXI_BRESP),
    .S_AXI_BVALID           (S_AXI_BVALID),
    .S_AXI_AWREADY          (S_AXI_AWREADY),
   
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
//registers logic, current logic is just a placeholder for initial compil, required to be changed by the user
always @(posedge axi_aclk)
	if (~resetn_sync) begin
		ro_reg <= #1    `REG_RO_DEFAULT;
		roc_reg <= #1    `REG_ROC_DEFAULT;
		ip2cpu_rwcr_reg <= #1    `REG_RWCR_DEFAULT;
		ip2cpu_rwcw_reg <= #1    `REG_RWCW_DEFAULT;
		cpu_rwcw_reg_clear_d <= #1    'h0
;		ip2cpu_rwa_reg <= #1    `REG_RWA_DEFAULT;
	end
	else begin
		ro_reg <= #1    `REG_RO_DEFAULT;
		roc_reg <= #1  roc_reg_clear ? 'h0  : `REG_ROC_DEFAULT;
		ip2cpu_rwcr_reg <= #1  rwcr_reg_clear ? 'h0  : `REG_RWCR_DEFAULT;
		ip2cpu_rwcw_reg <= #1  rwcw_reg_clear_d ? 'h0  :    `REG_RWCW_DEFAULT;
		cpu_rwcw_reg_clear_d <= #1    cpu_rwcw_reg_clear;
		ip2cpu_rwa_reg <= #1    `REG_RWA_DEFAULT;
        end

