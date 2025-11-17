class axi_monitor extends uvm_monitor;

    virtual axi4lite_if vif;
    uvm_analysis_port #(axi_seq_item) ap;

    `uvm_component_utils(axi_monitor);

    function new(string name="axi_monitor", uvm_component parent = null);
        super.new(parent);
        ap = new("ap", this);
    endfunction

    function void build_phase(uvm_phase phase);
        if(!uvm_config_db#(virtual axi4lite_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "No virtual IF for monitor");
    endfunction

    task run_phase(uvm_phase phase);
        forever begin
            //TODO: sample bus
            //create item and send to analysis port
        end
    endtask

endclass