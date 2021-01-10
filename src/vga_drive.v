module  vga_drive(
        //system    signals
        input                   sclk                    ,
        input                   s_rst_n                 ,
        //VGA
        output      wire        vga_hsync               ,
        output      wire        vga_vsync               ,
        output      reg [15:0] vga_rgb                 

);
//=========================================================================================//
//****************      Define parameter and internal signals        **********************//
//=========================================================================================//
//640x480x

localparam                  H_TOTAL_TIME    =       800     ;
localparam                  H_ADDR_TIME     =       640     ;
localparam                  H_SYNC_TIME     =       96      ;
localparam                  H_BACK_PORCH    =       40      ;
localparam                  H_LEFT_BORDER   =       8       ; 

localparam                  V_TOTAL_TIME    =       525     ;
localparam                  V_ADDR_TIME     =       480     ;
localparam                  V_SYNC_TIME     =       2       ;
localparam                  V_BACK_PORCH    =       25      ;
localparam                  V_TOP_BORDER    =       8       ;
localparam                  SQUARE_SIZE     =       200     ;
reg         [ 9:0]          cnt_h                       ;
reg         [ 9:0]          cnt_v                       ;


//============================================================================================//
//**********************          MAIN    CODE              **********************************//
//============================================================================================//
always  @(posedge sclk or negedge s_rst_n)  begin
        if(!s_rst_n)
                cnt_h   <=      'd0;
        else if(cnt_h   >=  (H_TOTAL_TIME -1 ))
                cnt_h   <=      'd0;
        else
                cnt_h   <=      cnt_h   +   1'b1;
end


always  @(posedge sclk or negedge s_rst_n)  begin
        if(!s_rst_n)
                cnt_v   <=      'd0;
        else if(cnt_v   >=  (V_TOTAL_TIME -1 ) && cnt_v >= (H_TOTAL_TIME - 1))
                cnt_v   <=      'd0;
        else if(cnt_h >= (H_TOTAL_TIME - 1))
                cnt_v   <=      cnt_v   +   1'b1;
end

always  @(posedge sclk or negedge s_rst_n)  begin
        if(!s_rst_n)
                vga_rgb <=      'd0;
        else if(cnt_h >= (H_SYNC_TIME +H_BACK_PORCH + H_LEFT_BORDER - 1) && cnt_h < (H_SYNC_TIME + H_BACK_PORCH  + H_LEFT_BORDER + H_ADDR_TIME - 1))  begin
                if( cnt_h >=( H_SYNC_TIME + H_BACK_PORCH + H_LEFT_BORDER - 1) && cnt_h <( H_SYNC_TIME + H_BACK_PORCH + H_LEFT_BORDER + SQUARE_SIZE - 1 ) &&
                    cnt_v >=( V_SYNC_TIME + V_BACK_PORCH + V_TOP_BORDER - 1) && cnt_v <( V_SYNC_TIME + V_BACK_PORCH + V_TOP_BORDER  + SQUARE_SIZE - 1 ))
                        vga_rgb     <=      16'hffff;
                else if( cnt_v >=( V_SYNC_TIME + V_BACK_PORCH + V_TOP_BORDER - 1) && cnt_v <( V_SYNC_TIME + V_BACK_PORCH + V_TOP_BORDER + 159 ))
                        vga_rgb     <=      {5'h1f,11'h0};          //red
                    
                else if( cnt_v >=( V_SYNC_TIME + V_BACK_PORCH + V_TOP_BORDER + 159) && cnt_v <( V_SYNC_TIME + V_BACK_PORCH + V_TOP_BORDER + 319 ))
                        vga_rgb     <=      {5'h0,6'h3f,5'h0};      //green
                            
                else if( cnt_v >=( V_SYNC_TIME + V_BACK_PORCH + V_TOP_BORDER + 319) && cnt_v <(  V_SYNC_TIME + V_BACK_PORCH + V_TOP_BORDER + 479 ))
                        vga_rgb     <=      {5'h0,6'h00,5'h1f};      //blue
                else
                        vga_rgb     <=      16'h0;
        end
        else
                vga_rgb     <=  16'h0;
end

assign  vga_hsync       =       (cnt_h < H_SYNC_TIME) ? 1'b1 : 1'b0 ;
assign  vga_vsync       =       (cnt_v < V_SYNC_TIME) ? 1'b1 : 1'b0 ;

endmodule
