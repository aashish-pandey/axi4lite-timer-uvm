class timer_cov extends uvm_component;

    `uvm_component_utils(timer_cov)

    // Monitor analysis implementation
    uvm_analysis_imp #(axi_seq_item, timer_cov) monitor_ap;

    // Virtual interface for clock access
    virtual axi4lite_if vif;

    // -------------------------------
    // Covergroups
    // -------------------------------
    covergroup cg_reg_access @(posedge vif.ACLK);
        option.per_instance = 1;

        cp_is_write : coverpoint tr_is_write {
            bins read  = {0};
            bins write = {1};
        }

        cp_addr : coverpoint tr_addr {
            bins CTRL    = {4'h0};
            bins LOAD    = {4'h4};
            bins COUNT   = {4'h8};
            bins IRQSTAT = {4'hC};
            bins others  = default;
        }

        x_op_addr : cross cp_is_write, cp_addr;
    endgroup


    covergroup cg_ctrl_bits @(posedge vif.ACLK);
        option.per_instance = 1;

        cp_start : coverpoint tr_wdata[0] {
            bins start0 = {0};
            bins start1 = {1};
        }

        cp_stop : coverpoint tr_wdata[1] {
            bins stop0 = {0};
            bins stop1 = {1};
        }

        x_start_stop : cross cp_start, cp_stop;
    endgroup


    covergroup cg_irq @(posedge vif.ACLK);
        option.per_instance = 1;

        cp_irqstat_write : coverpoint tr_irq_clear_write {
            bins clear0 = {0};
            bins clear1 = {1};
        }

        cp_irq_event : coverpoint tr_irq_event {
            bins irq0 = {0};
            bins irq1 = {1};
        }

        x_irq : cross cp_irqstat_write, cp_irq_event;
    endgroup;


    // -------------------------------
    // Internal Sampling Variables
    // -------------------------------
    bit tr_is_write;
    bit [3:0] tr_addr;
    bit [31:0] tr_wdata;

    bit tr_irq_clear_write;
    bit tr_irq_event;


    // -------------------------------
    // Constructor
    // -------------------------------
    function new(string name="timer_cov", uvm_component parent = null);
        super.new(name, parent);
        monitor_ap = new("monitor_ap", this);
    endfunction


    // -------------------------------
    // Build phase — construct covergroups
    // -------------------------------
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(!uvm_config_db#(virtual axi4lite_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "Coverage: No vif provided")

        cg_reg_access = new();
        cg_ctrl_bits  = new();
        cg_irq        = new();
    endfunction


    // -------------------------------
    // Write from monitor → coverage
    // -------------------------------
    function void write(axi_seq_item tr);

        tr_is_write = tr.is_write;
        tr_addr     = tr.addr;
        tr_wdata    = tr.wdata;

        tr_irq_clear_write = (tr.is_write && tr.addr == 4'hC);
        tr_irq_event       = (tr.is_write && tr.wdata != 0);

        cg_reg_access.sample();

        if (tr.addr == 4'h0)
            cg_ctrl_bits.sample();

        cg_irq.sample();
    endfunction

endclass
