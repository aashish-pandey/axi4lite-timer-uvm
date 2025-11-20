class axi_agent extends uvm_agent;

    axi_sequencer sqr;
    axi_driver    drv;
    axi_monitor   mon;

    `uvm_component_utils(axi_agent)

    function new(string name = "axi_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction


    // ---------------------------------------------------------
    // Build Phase
    // ---------------------------------------------------------
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        sqr = axi_sequencer::type_id::create("sqr", this);
        drv = axi_driver   ::type_id::create("drv", this);
        mon = axi_monitor  ::type_id::create("mon", this);
    endfunction


    // ---------------------------------------------------------
    // Connect Phase
    // ---------------------------------------------------------
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        drv.seq_item_port.connect(sqr.seq_item_export);
    endfunction


endclass
