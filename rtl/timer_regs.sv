module timer_regs
#(
    parameter AW = 4, 
    parameter DW = 32
) (
    input  logic        clk, 
    input  logic        rstn,

    // Write interface
    input  logic [AW-1:0] wr_addr,
    input  logic [DW-1:0] wr_data,
    input  logic          wr_en,
    output logic          wr_ready,

    // Read interface
    input  logic [AW-1:0] rd_addr,
    input  logic          rd_en,
    output logic [DW-1:0] rd_data,
    output logic          rd_valid,

    // Timer core connections
    output logic          start,
    output logic          stop,
    output logic [31:0]   load_val,
    input  logic [31:0]   cur_count,
    input  logic          irq,
    output logic          irq_clear
);

    //------------------------------------
    // REGISTER DEFINITIONS
    //------------------------------------
    logic [31:0] CTRL;     // bit0=start, bit1=stop
    logic [31:0] LOAD;     // reload value
    logic [31:0] IRQSTAT;  // interrupt status
    // COUNT is read-only from core → use cur_count

    //------------------------------------
    // WRITE LOGIC
    //------------------------------------
    
    assign wr_ready = 1'b1; // always ready

    always_ff @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            CTRL    <= '0;
            LOAD    <= '0;
            IRQSTAT <= '0;
        end
        else if (wr_en) begin
            case (wr_addr)
                4'h0: CTRL <= wr_data;
                4'h4: LOAD <= wr_data;
                4'hC: IRQSTAT <= wr_data;  // write 1 to clear irq
            endcase
        end
    end

    // IRQ clear signal to timer core
    assign irq_clear = wr_en && (wr_addr == 4'hC) && (wr_data != 0);


    //------------------------------------
    // READ LOGIC
    //------------------------------------
    always_comb begin
        case (rd_addr)
            4'h0: rd_data = CTRL;
            4'h4: rd_data = LOAD;
            4'h8: rd_data = cur_count;
            4'hC: rd_data = IRQSTAT;
            default: rd_data = 32'hDEADBEEF;
        endcase
    end

    // For now: rd_valid is 1 during rd_en
    assign rd_valid = rd_en;


    //------------------------------------
    // CONNECT CONTROL SIGNALS TO CORE
    //------------------------------------
    assign start    = CTRL[0];
    assign stop     = CTRL[1];
    assign load_val = LOAD;

endmodule
