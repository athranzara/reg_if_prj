//
// Copyright (c) 2015 University of Cambridge
// Copyright (c) 2015 Noa Zilberman
// All rights reserved.
//
//
//  File:
//        cpu_sync.v
//
//  Module:
//        cpu_sync
//
//  Author:
//        Noa Zilberman
//
//  Description:
//        This file is automatically generated with the registers towards the CPU/Software
//        and is responsible for clocks synchronization
//
// This software was developed by the University of Cambridge Computer Laboratory \n\
// under EPSRC INTERNET Project EP/H040536/1, National Science Foundation under Grant No. CNS-0855268,\n\
// and Defense Advanced Research Projects Agency (DARPA) and Air Force Research Laboratory (AFRL),\n\ 
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


module cpu_sync 
#(
    parameter C_S_AXI_DATA_WIDTH    = 32,          
    parameter C_S_AXI_ADDR_WIDTH    = 32         
  )
(
    // axi signal
    input       S_AXI_ARVALID,
    
    input       bus2ip_rden,
    
    output      ip2bus_fifo_empty,
    
    //ip clock domain
    input       clk,
    input       resetn,

    output [C_S_AXI_DATA_WIDTH-1 : 0]               bus2ip_data_ip,
    input   [C_S_AXI_DATA_WIDTH-1 : 0]              ip2bus_data_ip,

    // axi clock domain
    input       AXI_ACLK,
    input       Bus2IP_Resetn,
    
    input   [C_S_AXI_DATA_WIDTH-1 : 0]              bus2ip_data,
    input   [C_S_AXI_DATA_WIDTH/8 -1 : 0]           axi_wstrb,
    output  [C_S_AXI_DATA_WIDTH-1 : 0]              ip2bus_data

);


  //Wires and signals

    wire [C_S_AXI_DATA_WIDTH-1 : 0]           sync_IP2Bus_Data;

    wire                                      bus2ip_fifo_empty;
    wire                                      bus2ip_fifo_almost_full;
    wire                                      ip2bus_fifo_almost_full;

localparam  INIT = 0;
localparam  WRT = 1;
localparam  PENDING = 2;

//wire bus2ip_sync_valid;

// From IP to AXI
    wire         wren_bus2ip;
    reg [1:0]   state, next_state;
    always @ (*) begin
        next_state = state;
        case (state)
        INIT:
            begin
                if (~wren_bus2ip && S_AXI_ARVALID)
                    next_state = WRT;
            end
        WRT:
            begin
                next_state = PENDING;
            end
        PENDING:
            begin
                if (~S_AXI_ARVALID)
                    next_state = INIT;
            end     
        endcase   
    end

    assign wren_bus2ip = (state == WRT) ? 1'b1 : 1'b0;
    
    always @ (posedge clk) begin
        if (!resetn) begin
            state <= 2'b0;
        end
        else begin
            state <= next_state;
        end
    end 


    small_async_fifo #(
        .DSIZE (C_S_AXI_DATA_WIDTH),
        .ASIZE (4),
        .ALMOST_FULL_SIZE (14),
        .ALMOST_EMPTY_SIZE (2)
    ) ip2bus_async_fifo (
        .wdata(ip2bus_data_ip), /*Bus2IP_BE*/
        .winc(wren_bus2ip),
        .wclk(clk),
        
        .rdata(ip2bus_data), /*Bus2IP_BE_sync*/
        .rinc(bus2ip_rden),
        .rclk(AXI_ACLK),
        
        .rempty(ip2bus_fifo_empty),
        .r_almost_empty(),
        .wfull(),
        .w_almost_full(ip2bus_fifo_almost_full),
        .rrst_n(resetn),
        .wrst_n(Bus2IP_Resetn)
    );

// From AXI to IP

    small_async_fifo 
    #(
        .DSIZE (C_S_AXI_DATA_WIDTH),
        .ASIZE (4),
        .ALMOST_FULL_SIZE (14),
        .ALMOST_EMPTY_SIZE (2)
    ) 
    bus2ip_async_fifo
    (
        .wdata(bus2ip_data), /*Bus2IP_BE*/
        .winc(~bus2ip_fifo_almost_full),
        .wclk(AXI_ACLK),
        
        .rdata(bus2ip_data_ip), /*Bus2IP_BE_sync*/
        .rinc(~bus2ip_fifo_empty),
        .rclk(clk),
        
        .rempty(bus2ip_fifo_empty),
        .r_almost_empty(),
        .wfull(),
        .w_almost_full(bus2ip_fifo_almost_full),
        .rrst_n(resetn),
        .wrst_n(Bus2IP_Resetn)
    );

    
 endmodule 
