module top_timer(
    input  logic       ACLK,
    input  logic       ARESETn,

    // AXI4-Lite interface
    axi4lite_if axi
);

    // ---------------------------------------------------------
    // Internal AXI decode signals
    // ---------------------------------------------------------
    logic        wr_en;
    logic [3:0]  wr_addr;
    logic [31:0] wr_data;

    logic        rd_en;
    logic [3:0]  rd_addr;
    logic [31:0] rd_data;

    logic        irq_clear;

    // ---------------------------------------------------------
    // AXI4-Lite WRITE (simple slave)
    // ---------------------------------------------------------
    assign wr_en   = axi.AWVALID & axi.WVALID;
    assign wr_addr = axi.AWADDR;
    assign wr_data = axi.WDATA;

    assign axi.AWREADY = 1'b1;
    assign axi.WREADY  = 1'b1;

    assign axi.BVALID  = wr_en;
    assign axi.BRESP   = 2'b00;

    // ---------------------------------------------------------
    // CORRECT AXI4-Lite READ LOGIC (NO HANG)
    // ---------------------------------------------------------
    logic [3:0] latched_rd_addr;
    logic       read_pending;

    assign axi.ARREADY = 1'b1;

    always_ff @(posedge ACLK or negedge ARESETn) begin
        if (!ARESETn) begin
            latched_rd_addr <= '0;
            read_pending    <= 1'b0;
        end
        else begin
            // Address phase
            if (axi.ARVALID && axi.ARREADY) begin
                latched_rd_addr <= axi.ARADDR;
                read_pending    <= 1'b1;
            end

            // Read transaction completes
            if (axi.RVALID && axi.RREADY) begin
                read_pending <= 1'b0;
            end
        end
    end

    assign rd_addr  = latched_rd_addr;
    assign rd_en    = read_pending;

    assign axi.RDATA = rd_data;
    assign axi.RRESP = 2'b00;
    assign axi.RVALID = read_pending;

    // ---------------------------------------------------------
    // Register Block
    // ---------------------------------------------------------
    logic start, stop;
    logic [31:0] load_val;
    logic [31:0] cur_count;
    logic        irq;

    timer_regs regs (
        .clk       (ACLK),
        .rstn      (ARESETn),

        .wr_addr   (wr_addr),
        .wr_data   (wr_data),
        .wr_en     (wr_en),
        .wr_ready  (/* unused */),

        .rd_addr   (rd_addr),
        .rd_en     (rd_en),
        .rd_data   (rd_data),
        .rd_valid  (/* unused */),

        .start     (start),
        .stop      (stop),
        .load_val  (load_val),
        .cur_count (cur_count),
        .irq       (irq),

        .irq_clear (irq_clear)
    );

    // ---------------------------------------------------------
    // Timer Core
    // ---------------------------------------------------------
    timer_core core (
        .clk       (ACLK),
        .rstn      (ARESETn),

        .start     (start),
        .stop      (stop),
        .load_val  (load_val),

        .cur_count (cur_count),
        .irq       (irq),

        .irq_clear (irq_clear)
    );

endmodule
