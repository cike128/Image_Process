// *********************************************************************************
// Project Name : OSXXXX
// Author       : dengkanwen
// Email        : dengkanwen@163.com
// Website      : http://www.opensoc.cn/
// Create Time  : 2021/1/3 10:40:31
// File Name    : .v
// Module Name  : 
// Called By    :
// Abstract     :
//
// CopyRight(c) 2016, OpenSoc Studio.. 
// All Rights Reserved
//
// *********************************************************************************
// Modification History:
// Date         By              Version                 Change Description
// -----------------------------------------------------------------------
// 2021/1/3    Kevin           1.0                     Original
//  
// *********************************************************************************
`timescale      1ns/1ns

module  top(
        //system signals
        input                   sclk                    ,      //50MHz 
        input                   s_rst_n                 ,      //rst 
        //VGA
        output wire             vga_vsync               ,       //场同步
        output wire             vga_hsync               ,       //行同步
        output wire      [15:0] vga_rgb                              

);

//========================================================================\
// =========== Define Parameter and Internal signals =========== 
//========================================================================
reg                             clk_25m                         ;       



//=============================================================================
//**************    Main Code   **************
//=============================================================================/
always  @(posedge sclk or negedge s_rst_n) begin
        if(s_rst_n == 1'b0)
                clk_25m <=  1'b0    ;
        else
                clk_25m <=  ~clk_25m;
end

vga_drive       vga_drive_inst(
        //system    signals
        .sclk                   ( clk_25m              ),
        .s_rst_n                (s_rst_n                ),
        //VGA
        .vga_hsync              (vga_hsync              ),
        .vga_vsync              (vga_vsync              ),
        .vga_rgb                (vga_rgb                )

);


endmodule








