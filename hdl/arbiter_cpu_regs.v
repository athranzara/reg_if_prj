//
// Copyright (c) 2015 University of Cambridge
// All rights reserved.
//
//
//  File:
//        arbiter_cpu_regs.v
//
//  Module:
//        arbiter_cpu_regs
//
//  Description:
//        This file is automatically generated with the registers towards the CPU/Software
//
// This software was developed by the University of Cambridge Computer Laboratory 
// under EPSRC INTERNET Project EP/H040536/1, National Science Foundation under Grant No. CNS-0855268,
// and Defense Advanced Research Projects Agency (DARPA) and Air Force Research Laboratory (AFRL),
// under contract FA8750-11-C-0249.
//
// @NETFPGA_LICENSE_HEADER_START@
//
// Licensed to NetFPGA Open Systems C.I.C. (NetFPGA) under one or more contributor
// license agreements.  See the NOTICE file distributed with this work for
// additional information regarding copyright ownership.  NetFPGA licenses this
// file to you under the NetFPGA Hardware-Software License, Version 1.0 (the
// "License"); you may not use this file except in compliance with the
// License.  You may obtain a copy of the License at:
//
//   http://www.<future link here>
//
// Unless required by applicable law or agreed to in writing, Work distributed
// under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations under the License.
//
// @NETFPGA_LICENSE_HEADER_END@
//

`include "arbiter_cpu_regs_defines.v"
module arbiter_cpu_regs # 
(
parameter C_BASE_ADDRESS        = 32'h00000000,
parameter C_S_AXI_DATA_WIDTH    = 32,
parameter C_S_AXI_ADDR_WIDTH    = 32
)
(
    // General ports
    input       clk,
    input       resetn,
    // Global Registers
    input       cpu_resetn_soft,
    output reg  resetn_soft,
    output reg  resetn_sync,

   // Register ports
    input      [`REG_RO_BITS]    ro_reg,
    output reg [`REG_WO_BITS]    wo_reg,
    output reg [`REG_WOE_BITS]    woe_reg,
    input      [`REG_ROC_BITS]    roc_reg,
    output reg                          roc_reg_clear,
    output reg [`REG_RWS_BITS]    rws_reg,
    input      [`REG_RWCR_BITS]    ip2cpu_rwcr_reg,
    output reg [`REG_RWCR_BITS]    cpu2ip_rwcr_reg,
    output reg                          cpu2ip_rwcr_reg_clear,
    input      [`REG_RWCW_BITS]    ip2cpu_rwcw_reg,
    output reg [`REG_RWCW_BITS]    cpu2ip_rwcw_reg,
    output reg                          cpu2ip_rwcw_reg_clear,
    input      [`REG_RWA_BITS]    ip2cpu_rwa_reg,
    output reg [`REG_RWA_BITS]    cpu2ip_rwa_reg,

    // AXI Lite ports
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

);

    // AXI4LITE signals
    reg [C_S_AXI_ADDR_WIDTH-1 : 0]      axi_awaddr;
    reg                                 axi_awready;
    reg                                 axi_wready;
    reg [1 : 0]                         axi_bresp;
    reg                                 axi_bvalid;
    reg [C_S_AXI_ADDR_WIDTH-1 : 0]      axi_araddr;
    reg                                 axi_arready;
    reg [C_S_AXI_DATA_WIDTH-1 : 0]      axi_rdata;
    reg [1 : 0]                         axi_rresp;
    reg                                 axi_rvalid;
  
    reg                                 resetn_sync_d;
    wire                                reg_rden;
    wire                                reg_wren;
    reg [C_S_AXI_DATA_WIDTH-1:0]        reg_data_out;
    reg [C_S_AXI_DATA_WIDTH-1:0]        s_axi_wstrb_bit;
    integer                             bit_index;
    reg                                             cpu2ip_rwcw_reg_clear_d;

    // I/O Connections assignments 
    assign S_AXI_AWREADY    = axi_awready;
    assign S_AXI_WREADY     = axi_wready;
    assign S_AXI_BRESP      = axi_bresp;
    assign S_AXI_BVALID     = axi_bvalid;
    assign S_AXI_ARREADY    = axi_arready;
    assign S_AXI_RDATA      = axi_rdata;
    assign S_AXI_RRESP      = axi_rresp;
    assign S_AXI_RVALID     = axi_rvalid;
    
    always @ * begin :assignment 
    integer byte_index;
        for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
            if ( S_AXI_WSTRB[byte_index] == 1'b1 ) begin
                    s_axi_wstrb_bit[(byte_index*8) +: 8] = 8'hff;
            end 
    end

    //Sample reset (not mandatory, but good practice)
    always @ (posedge clk) begin
        if (~resetn) begin
            resetn_sync_d  <=  1'b0;
            resetn_sync    <=  1'b0;
        end
        else begin
            resetn_sync_d  <=  resetn;
            resetn_sync    <=  resetn_sync_d;
        end
    end
    

    //global registers, sampling
    always @(posedge clk) resetn_soft <= #1 cpu_resetn_soft;

    // Implement axi_awready generation
    // axi_awready is asserted for one S_AXI_ACLK clock cycle when both
    // S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_awready is
    // de-asserted when reset is low.

    always @( posedge S_AXI_ACLK )
    begin
      if ( S_AXI_ARESETN == 1'b0 )
        begin
          axi_awready <= 1'b0;
        end 
      else
        begin    
          if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID)
            begin
              // slave is ready to accept write address when 
              // there is a valid write address and write data
              // on the write address and data bus. This design 
              // expects no outstanding transactions. 
              axi_awready <= 1'b1;
            end
          else           
            begin
              axi_awready <= 1'b0;
            end
        end 
    end       

    // Implement axi_awaddr latching
    // This process is used to latch the address when both 
    // S_AXI_AWVALID and S_AXI_WVALID are valid. 

    always @( posedge S_AXI_ACLK )
    begin
      if ( S_AXI_ARESETN == 1'b0 )
        begin
          axi_awaddr <= 0;
        end 
      else
        begin    
          if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID)
            begin
              // Write Address latching 
              axi_awaddr <= S_AXI_AWADDR ^ C_BASE_ADDRESS;
            end
        end 
    end       

    // Implement axi_wready generation
    // axi_wready is asserted for one S_AXI_ACLK clock cycle when both
    // S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_wready is 
    // de-asserted when reset is low. 

    always @( posedge S_AXI_ACLK )
    begin
      if ( S_AXI_ARESETN == 1'b0 )
        begin
          axi_wready <= 1'b0;
        end 
      else
        begin    
          if (~axi_wready && S_AXI_WVALID && S_AXI_AWVALID)
            begin
              // slave is ready to accept write data when 
              // there is a valid write address and write data
              // on the write address and data bus. This design 
              // expects no outstanding transactions. 
              axi_wready <= 1'b1;
            end
          else
            begin
              axi_wready <= 1'b0;
            end
        end 
    end       

    // Implement write response logic generation
    // The write response and response valid signals are asserted by the slave 
    // when axi_wready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted.  
    // This marks the acceptance of address and indicates the status of 
    // write transaction.

    always @( posedge S_AXI_ACLK )
    begin
      if ( S_AXI_ARESETN == 1'b0 )
        begin
          axi_bvalid  <= 0;
          axi_bresp   <= 2'b0;
        end 
      else
        begin    
          if (axi_awready && S_AXI_AWVALID && ~axi_bvalid && axi_wready && S_AXI_WVALID)
            begin
              // indicates a valid write response is available
              axi_bvalid <= 1'b1;
              axi_bresp  <= 2'b0; // OKAY response 
            end                   // work error responses in future
          else
            begin
              if (S_AXI_BREADY && axi_bvalid) 
                //check if bready is asserted while bvalid is high) 
                //(there is a possibility that bready is always asserted high)   
                begin
                  axi_bvalid <= 1'b0; 
                end  
            end
        end
    end   

    // Implement axi_arready generation
    // axi_arready is asserted for one S_AXI_ACLK clock cycle when
    // S_AXI_ARVALID is asserted. axi_awready is 
    // de-asserted when reset (active low) is asserted. 
    // The read address is also latched when S_AXI_ARVALID is 
    // asserted. axi_araddr is reset to zero on reset assertion.

    always @( posedge S_AXI_ACLK )
    begin
      if ( S_AXI_ARESETN == 1'b0 )
        begin
          axi_arready <= 1'b0;
          axi_araddr  <= 32'b0;
        end 
      else
        begin    
          if (~axi_arready && S_AXI_ARVALID)
            begin
              // indicates that the slave has acceped the valid read address
              // user modfied here
                if (~ip2bus_fifo_empty)
                    axi_arready <= 1'b1;
              // Read address latching
              axi_araddr  <= S_AXI_ARADDR ^ C_BASE_ADDRESS;
            end
          else
            begin
              axi_arready <= 1'b0;
            end
        end 
    end       

    // Implement axi_arvalid generation
    // axi_rvalid is asserted for one S_AXI_ACLK clock cycle when both 
    // S_AXI_ARVALID and axi_arready are asserted. The slave registers 
    // data are available on the axi_rdata bus at this instance. The 
    // assertion of axi_rvalid marks the validity of read data on the 
    // bus and axi_rresp indicates the status of read transaction.axi_rvalid 
    // is deasserted on reset (active low). axi_rresp and axi_rdata are 
    // cleared to zero on reset (active low).  
    always @( posedge S_AXI_ACLK )
    begin
      if ( S_AXI_ARESETN == 1'b0 )
        begin
          axi_rvalid <= 0;
          axi_rresp  <= 0;
        end 
      else
        begin    
          if (axi_arready && S_AXI_ARVALID && ~axi_rvalid)
            begin
              // Valid read data is available at the read data bus
              axi_rvalid <= 1'b1;
              axi_rresp  <= 2'b0; // OKAY response
            end   
          else if (axi_rvalid && S_AXI_RREADY)
            begin
              // Read data is accepted by the master
              axi_rvalid <= 1'b0;
            end                
        end
    end    


    // Implement memory mapped register select and write logic generation
    // The write data is accepted and written to memory mapped registers when
    // axi_awready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted. Write strobes are used to
    // select byte enables of slave registers while writing.
    // These registers are cleared when reset (active low) is applied.
    // Slave register write enable is asserted when valid address and data are available
    // and the slave is ready to accept the write address and write data.
    assign reg_wren = axi_wready && S_AXI_WVALID && axi_awready && S_AXI_AWVALID;

//////////////////////////////////////////////////////////////
// write registers
//////////////////////////////////////////////////////////////
    

//Write only register, not cleared
    //static  
    always @(posedge clk)
        if (!resetn_sync) begin
            wo_reg <= #1 `REG_WO_DEFAULT;
        end
        else begin
            if (reg_wren) begin //write event
                case (axi_awaddr)
                //Wo Register
                    `REG_WO_ADDR : begin
                            for ( bit_index = 0; bit_index <= (`REG_WO_WIDTH-1); bit_index = bit_index +1)
                                if (s_axi_wstrb_bit[bit_index] == 1) begin
                                    wo_reg[bit_index] <=  S_AXI_WDATA[bit_index];
                                end
                    end
                endcase
            end
        end

//Write only register, clear on write (i.e. event)
    always @(posedge clk) begin
        if (!resetn_sync) begin
            woe_reg <= #1 `REG_WOE_DEFAULT;
        end
        else begin
            if (reg_wren) begin
                case (axi_awaddr)
                //Woe Register
                    `REG_WOE_ADDR : begin
                            for ( bit_index = 0; bit_index <= (`REG_WOE_WIDTH-1); bit_index = bit_index +1)
                                if (s_axi_wstrb_bit[bit_index] == 1) begin
                                    woe_reg[bit_index] <=  S_AXI_WDATA[bit_index];
                                end
                    end
                endcase
            end 
        end
    end

//R/W register, not cleared
    always @(posedge clk) begin
        if (!resetn_sync) begin
        
            rws_reg <= #1 `REG_RWS_DEFAULT;
            cpu2ip_rwa_reg <= #1 `REG_RWA_DEFAULT;
        end
        else begin
           if (reg_wren) //write event
            case (axi_awaddr)
            //Rws Register
                `REG_RWS_ADDR : begin
                        for ( bit_index = 0; bit_index <= (`REG_RWS_WIDTH-1); bit_index = bit_index +1)
                            if (s_axi_wstrb_bit[bit_index] == 1) begin
                                rws_reg[bit_index] <=  S_AXI_WDATA[bit_index]; //static register;
                            end
                end
            //Rwa Register
                `REG_RWA_ADDR : begin
                        for ( bit_index = 0; bit_index <= (`REG_RWA_WIDTH-1); bit_index = bit_index +1)
                            if (s_axi_wstrb_bit[bit_index] == 1) begin
                                cpu2ip_rwa_reg[bit_index] <=  S_AXI_WDATA[bit_index]; //dynamic register;
                            end
                end
                default: begin
                end
                
            endcase
        end
    end

//R/W register, clear on read
    always @(posedge clk) begin
        if (!resetn_sync) begin
            
            cpu2ip_rwcr_reg <= #1 `REG_RWCR_DEFAULT;
        end
        else begin
            if (reg_wren)
                case (axi_awaddr)
                //Rwcr Register
                `REG_RWCR_ADDR : begin
                        for ( bit_index = 0; bit_index <= (`REG_RWCR_WIDTH-1); bit_index = bit_index +1)
                            if (s_axi_wstrb_bit[bit_index] == 1) begin
                                cpu2ip_rwcr_reg[bit_index] <=  S_AXI_WDATA[bit_index];
                            end
                end
                endcase
        end
    end


//clear assertions
    always @(posedge clk) begin
        if (!resetn_sync) begin
            cpu2ip_rwcr_reg_clear <=  #1 1'b0;
        end
        else begin
             cpu2ip_rwcr_reg_clear <=  #1 reg_rden && (axi_awaddr==`REG_RWCR_ADDR) ? 1'b1 : 1'b0;

        end
    end

//R/W register, clear on write, dynamic
// i.e. on write - write, next clock - write default value
    always @(posedge clk) begin
        if (!resetn_sync) begin
            cpu2ip_rwcw_reg <= #1 `REG_RWCW_DEFAULT;
            cpu2ip_rwcw_reg_clear_d <= #1 1'b0;
            cpu2ip_rwcw_reg_clear   <= #1 1'b0;
        end
        else begin
            cpu2ip_rwcw_reg_clear   <=  cpu2ip_rwcw_reg_clear_d;
            cpu2ip_rwcw_reg_clear_d <=  reg_wren && (axi_awaddr==`REG_RWCW_ADDR) ? 1'b1 :  1'b0;
            if (reg_wren) begin
                if (axi_awaddr==`REG_RWCW_ADDR) begin
                    for ( bit_index = 0; bit_index <= (`REG_RWCW_WIDTH-1); bit_index = bit_index+1 )
                        if ( s_axi_wstrb_bit[bit_index] == 1 ) begin
                            cpu2ip_rwcw_reg[bit_index] <=  S_AXI_WDATA[bit_index];
                        end
                end
            end
        end
    end
    


/////////////////////////
//// end of write
/////////////////////////

    // Implement memory mapped register select and read logic generation
    // Slave register read enable is asserted when valid address is available
    // and the slave is ready to accept the read address.

    // reg_rden control logic
    // temperary no extra logic here
    assign reg_rden = axi_arready & S_AXI_ARVALID & ~axi_rvalid;
    

    always @(*)
    begin
//        reg_data_out = axi_rdata; /* some new changes here */
        
        if (S_AXI_ARVALID) begin
        
        case ( S_AXI_ARADDR ^ C_BASE_ADDRESS )
    
            //Ro Register
            `REG_RO_ADDR : begin
                reg_data_out [`REG_RO_BITS] =  ro_reg;
            end
            //Roc Register
            `REG_ROC_ADDR : begin
                reg_data_out [`REG_ROC_BITS] =  roc_reg;
            end
            //Rws Register
            `REG_RWS_ADDR : begin
                reg_data_out [`REG_RWS_BITS] =  rws_reg;
            end
            //Rwcr Register
            `REG_RWCR_ADDR : begin
                reg_data_out [`REG_RWCR_BITS] =  ip2cpu_rwcr_reg;
            end
            //Rwcw Register
            `REG_RWCW_ADDR : begin
                reg_data_out [`REG_RWCW_BITS] =  ip2cpu_rwcw_reg;
            end
            //Rwa Register
            `REG_RWA_ADDR : begin
                reg_data_out [`REG_RWA_BITS] =  ip2cpu_rwa_reg;
            end
            //Default return value
            default: begin 
                reg_data_out [31:0] =  32'hDEADBEEF;
            end
            
        endcase
        
        end
    end//end of assigning data to IP2Bus_Data bus
    

    //Read only registers, not cleared
    //Nothing to do here....
    
//Read only registers, cleared on read (e.g. counters)
    always @(posedge clk)
    if (!resetn_sync) begin
        roc_reg_clear <= #1 1'b0;
    end
    else begin
        roc_reg_clear <= #1(reg_rden && (axi_araddr==`REG_ROC_ADDR)) ? 1'b1 : 1'b0;
    end


// Output register or memory read data 
    always @( posedge S_AXI_ACLK )
    begin
      if ( S_AXI_ARESETN == 1'b0 )
        begin
          axi_rdata  <= 0;
        end 
      else
        begin    
          // When there is a valid read address (S_AXI_ARVALID) with 
          // acceptance of read address by the slave (axi_arready), 
          // output the read dada 
          if (reg_rden)
            begin
              axi_rdata <= ip2bus_data/*reg_data_out*/;     // register read data /* some new changes here */
            end   
        end
    end  
    

// synchronization stage

// sync stage signals
    wire [C_S_AXI_DATA_WIDTH-1:0]       bus2ip_data_ip;
    wire [C_S_AXI_DATA_WIDTH-1:0]       ip2bus_data;
    wire bus2ip_rden;
    wire ip2bus_fifo_empty;

    assign  bus2ip_rden = reg_rden;

    cpu_sync #(
        .C_S_AXI_DATA_WIDTH(C_S_AXI_DATA_WIDTH),
        .C_S_AXI_ADDR_WIDTH(C_S_AXI_ADDR_WIDTH)
    )cpu_sync_inst
        (
        .S_AXI_ARVALID(S_AXI_ARVALID),
        .bus2ip_rden(bus2ip_rden),
        .ip2bus_fifo_empty(ip2bus_fifo_empty),
        //ip clock domain
        .clk(clk),
        .resetn(resetn_sync),
        
        .bus2ip_data_ip(bus2ip_data_ip),
        .ip2bus_data_ip(reg_data_out),

        // axi clock domain
        .AXI_ACLK(S_AXI_ACLK),
        .Bus2IP_Resetn(S_AXI_ARESETN),

        .bus2ip_data(S_AXI_WDATA),
        .axi_wstrb(S_AXI_WSTRB),
        .ip2bus_data(ip2bus_data)
        );
    
endmodule
