module top_timer(
    input logic ACLK, 
    input logic ARESETn, 

    //AXI$-Lite interface
    axi4lite_if axi 
);

//Internal AXI decode signals
logic wr_en;
logic [3:0] wr_addr;
logic [31:0] wr_data;

logic rd_en;
logic [3:0] rd_addr;
logic [31:0] rd_data;


//---------------------------------------
// simple AXI$-Lite Slave Behavior 
//---------------------------------------

assign wr_en  = axi.AWVALID & axi.WVALID;
assign wr_addr = axi.AWADDR;
assign wr_data = axi.WDATA;

assign axi.AWREADY = 1'b1;
assign axi.WREADY = 1'b1;

assign axi.BVALID = wr_en;
assign axi.BRESP = 2'b00; //okay

assign rd_en = axi.ARVALID;
assign rd_addr = axi.ARADDR;

assign axi.ARREADY = 1'b1;

assign axi.RVALID = rd_en;
assign axi.RRESP  = 2'b00;
assign axi.RDATA  = rd_data;


//---------------------------------------------
// REG BLOCK
//---------------------------------------------
logic start, stop;
logic [31:0] load_val;
logic [31:0] cur_count;
logic irq;

timer_regs regs (
    .clk(ACLK),
    .rstn(ARESETn),

    .wr_addr(wr_addr),
    .wr_data(wr_data),
    .wr_en(wr_en),
    .wr_ready(),

    .rd_addr(rd_addr),
    .rd_en(rd_en),
    .rd_data(rd_data),
    .rd_valid(),

    .start(start),
    .stop(stop),
    .load_val(load_val),
    .cur_count(cur_count),
    .irq(irq)

);

//------------------------------------------
// TIMER CORE
//------------------------------------------

timer_core core (
    .clk(ACLK),
    .rstn(ARESETn),
    .start(start),
    .stop(stop),
    .load_val(load_val),
    .cur_count(cur_count),
    .irq(irq)
);


endmodule

