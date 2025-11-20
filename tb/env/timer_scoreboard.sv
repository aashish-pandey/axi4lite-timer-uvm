class timer_scoreboard extends uvm_component;

    // Analysis export for monitor
    uvm_analysis_imp #(axi_seq_item, timer_scoreboard) monitor_ap;

    // Reference model for registers
    bit [31:0] reg_model[string];

    `uvm_component_utils(timer_scoreboard)

    function new(string name="timer_scoreboard", uvm_component parent = null);
        super.new(name, parent);
        monitor_ap = new("monitor_ap", this);
    endfunction


    // ---------------------------------------------------------
    // Build phase — initialize reference model
    // ---------------------------------------------------------
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // default register values
        reg_model["CTRL"]    = 32'h0000_0000;
        reg_model["LOAD"]    = 32'h0000_0000;
        reg_model["COUNT"]   = 0;
        reg_model["IRQSTAT"] = 0;
    endfunction


    // ---------------------------------------------------------
    // Called by monitor for every transaction
    // ---------------------------------------------------------
    function void write(axi_seq_item tr);
        if (tr.is_write)
            process_write(tr);
        else
            process_read(tr);
    endfunction


    // ---------------------------------------------------------
    // Write Handling
    // ---------------------------------------------------------
    function void process_write(axi_seq_item tr);
        string name;

        case (tr.addr)
            4'h0: name = "CTRL";
            4'h4: name = "LOAD";
            4'hC: name = "IRQSTAT";
            default: begin
                `uvm_warning("SB_WRITE",
                    $sformatf("Invalid write address: 0x%0h", tr.addr))
                return;
            end
        endcase

        // Update reference model
        reg_model[name] = tr.wdata;

        `uvm_info("SB_WRITE",
            $sformatf("REFMODEL UPDATE: %s <= 0x%0h", name, tr.wdata),
            UVM_LOW)
    endfunction


    // ---------------------------------------------------------
    // Read Handling
    // ---------------------------------------------------------
    function void process_read(axi_seq_item tr);
        string name;
        bit [31:0] expected;

        case (tr.addr)
            4'h0: name = "CTRL";
            4'h4: name = "LOAD";
            4'h8: name = "COUNT";
            4'hC: name = "IRQSTAT";
            default: begin
                `uvm_warning("SB_READ",
                    $sformatf("Invalid read address: 0x%0h", tr.addr))
                return;
            end
        endcase

        expected = reg_model[name];

        if (tr.rdata !== expected) begin
            `uvm_error("SB_MATCH",
                $sformatf("READ MISMATCH @ %s: EXPECTED=0x%0h, GOT=0x%0h",
                name, expected, tr.rdata))
        end
        else begin
            `uvm_info("SB_READ",
                $sformatf("READ OK @ %s: 0x%0h", name, tr.rdata),
                UVM_LOW)
        end
    endfunction

endclass
