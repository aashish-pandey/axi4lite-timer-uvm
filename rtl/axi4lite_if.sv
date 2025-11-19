interface axi4lite_if #(
    parameter AW = 4, DW = 32
)(
    input logic ACLK, ARESETn
);

//write address channel
logic [AW-1:0] AWADDR;
logic   AWVALID;
logic   AWREADY;

//write Data channel;
logic [DW-1:0] WDATA;
logic [3:0]     WSTRB;
logic WVALID;
logic WREADY;


//write Response channel
logic [1:0] BRESP;
logic BVALID;
logic BREADY;

//Read Address channel
logic [AW-1:0] ARADDR;
logic ARVALID;
logic ARREADY;

//Read Data channel
logic [DW-1:0] RDATA;
logic [1:0] RRESP;
logic RVALID;
logic RREADY;

endinterface