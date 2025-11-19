class timer_cov extends uvm_component;
    `uvm_component_utils(timer_cov)

    uvm_analysis_imp #(axi_seq_item, timer_cov) monitor_ap;

    function new(string name="timer_cov", uvm_component parent = null);
        super.new(name, parent);
        monitor_ap = new("monitor_ap", this);
    endfunction

    //covergroup definitions
    covergroup cg_reg_access @(posedge clk);
        option.per_instance = 1;

        //Read or write op
        cp_is_write : coverpoint tr_is_write {
            bins read = {0};
            bins write = {1};
        }

        cp_addr : coverpoint tr_addr {
            bins CTRL = {4'h0};
            bins LOAD = {4'h4};
            bins COUNT = {4'h8};
            bins IRQSTAT = {4'hC};
            bins others = default;
        }

        x_op_addr : cross cp_is_Write, cp_addr;
    endgroup;

    //CTRL register bit functional group
    covergroup cg_ctrl_bits @(posedge clk);
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
    endgroup;

    //IRQ event coverage
    covergroup cg_irq @(posedge clk);
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

    endgroup

    //internal sampling variables

    bit tr_is_write;
    bit [3:0] tr_addr;
    bit [31:0] tr_wdata;

    bit tr_irq_clear_write;
    bit tr_irq_event;

    //write from monitor into coverage
    function void write(axi_seq_item tr);

        //extract data from transaction
        tr_is_write = tr.is_write;
        tr_addr = tr.addr;
        tr_wdata = tr.wdata;

        //special coverage signal
        tr_irq_clear_write = (tr.is_write && tr.addr == 4'hC);
        tr_irq_event = (tr.is_write && tr.wdata != 0);

        //sample covergroups
        cg_reg_access.sample();
        if (tr.addr == 4'h0) cg_ctrl_bits.sample();
        cg_irq.sample();
    endfunction


endclass