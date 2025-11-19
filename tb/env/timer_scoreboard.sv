class timer_scoreboard extends uvm_component;

    uvm_analysis_imp #(axi_seq_item, timer_scoreboard) monitor_ap;

    bit [31:0] reg_model [string];

    `uvm_component_utils(timer_scoreboard)

    function new(string name="timer_scoreboard", uvm_component parent = null);
        super.new(name, parent);
        monitor_ap = new("monitor_ap", this);
    endfunction

    //initialize reference model
    function void build_phase(uvm_phase, phase);
        super.build_phase(phase);

        //default register model values
        reg_model["CTRL"] = 32'h0000_0000;
        reg_model["LOAD"] = 32'h0000_0000;
        reg_model["COUNT"]  =32'h0000_0000;
        reg_model["IRQSTAT"]  =32'h0000_0000;
    endfunction

    //write from monitor into scoreboard
    function void write(axi_seq_item tr);
        if(tr.is_write)
            process_write(tr);
        else
            process_read(tr);
    endfunction

    //write checking
    function void process_write(axi_seq_item tr);
        string name;

        //Decode address -> register name
        case (tr.addr)
            4'h0: name = "CTRL";
            4'h4: name = "LOAD";
            4'hC: name = "IRQSTAT";
            default: begin
                `uvm_warning("SB_WRITE", 
                            $sformatf("Invalid write address 0x%0h", tr.addr) )
                return;

            end
        endcase

        //update model reference
        reg_model[name] = tr.wdata;

        `uvm_info("SB_WRITE", 
                    $sformatf("REFMODEL UPDATE: %s <= 0x%0h", name, tr.wdata),
                    UVM_LOW)
    endfunction

    //READ CHECKING
    function void process_read(axi_seq_item tr);
        string name;
        bit[31:0] expected;

        case(tr.addr)
            4'h0: name = "CTRL";
            4'h4: name = "LOAD";
            4'h8: name = "COUNT";
            4'hC: name = "IRQSTAT";
            default: begin
                `uvm_warning("SB_READ", 
                            $sformatf("Invalid read addr 0x%0h", tr.addr) )
                return;
            end
        endcase

        expected = reg_model[name];

        //compare expected vs actual
        if(tr.rdata != expected) begin
            `uvm_error("SB_MATCH", 
                        $sformatf("READ MISMATCH @ %s: EXPECTED=0x%0h, GOT=0x%0h",
                        name, expected, tr.rdata) )
        end
        else begin
            `uvm_info("SB_READ", 
                    $sformatf("READ OK @ %s: 0x%0h", name, tr.rdata),
                    UVM_LOW)
        end

    endfunction


    
endclass