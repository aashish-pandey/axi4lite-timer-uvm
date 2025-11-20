class timer_cov extends uvm_component;
    `uvm_component_utils(timer_cov)

    uvm_analysis_imp #(axi_seq_item, timer_cov) monitor_ap;

    // sampled variables
    bit         tr_is_write;
    bit [3:0]   tr_addr;
    bit [31:0]  tr_wdata;
    bit         tr_irq_clear_write;
    bit         tr_irq_event;

    covergroup cg_reg_access with function sample(bit is_wr, bit [3:0] addr);
        cp_is_write : coverpoint is_wr {
            bins read  = {0};
            bins write = {1};
        }

        cp_addr : coverpoint addr {
            bins CTRL   = {4'h0};
            bins LOAD   = {4'h4};
            bins COUNT  = {4'h8};
            bins IRQ    = {4'hC};
            bins others = default;
        }

        cross_is_addr : cross cp_is_write, cp_addr;
    endgroup

    covergroup cg_ctrl_bits with function sample(bit [31:0] wdata);
        cp_start : coverpoint wdata[0];
        cp_stop  : coverpoint wdata[1];
        cross_start_stop : cross cp_start, cp_stop;
    endgroup

    covergroup cg_irq with function sample(bit clear, bit evt);
        cp_clear : coverpoint clear;
        cp_evt   : coverpoint evt;
        cross_irq : cross cp_clear, cp_evt;
    endgroup

    function new(string name="timer_cov", uvm_component parent=null);
        super.new(name, parent);
        monitor_ap = new("monitor_ap", this);

        cg_reg_access = new();
        cg_ctrl_bits  = new();
        cg_irq        = new();
    endfunction

    function void write(axi_seq_item tr);
        tr_is_write         = tr.is_write;
        tr_addr             = tr.addr;
        tr_wdata            = tr.wdata;
        tr_irq_clear_write  = (tr.is_write && tr.addr == 4'hC);
        tr_irq_event        = (tr.is_write && tr.wdata != 0);

        cg_reg_access.sample(tr_is_write, tr_addr);

        if (tr.addr == 4'h0)
            cg_ctrl_bits.sample(tr_wdata);

        cg_irq.sample(tr_irq_clear_write, tr_irq_event);
    endfunction

endclass
