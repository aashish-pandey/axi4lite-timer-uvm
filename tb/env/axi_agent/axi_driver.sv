class axi_driver extends uvm_driver #(axi_seq_item);

    virtual axi4lite_if vif;

    `uvm_component_utils(axi_driver)

    function new(string name="axi_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual axi4lite_if) :: get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "No virtual interface provided for axi4_driver")
    endfunction

    task run_phase(uvm_phase phase)
        forever begin
            axi_seq_item req;
            seq_item_port.get_next_item(req);

            if(req.is_write)
                send_write(req);
            else
                send_read(req); 
            
            seq_item_port.item_done();
        end
    endtask

    //placeholder tasks (TO BE IMPLEMENTED)
    task send_write(axi_seq_item req);
        //TODO: add handshake logic
    endtask

    task send_read(axi_seq_item req);
        //TODO: add handshake logic
    endtask

endclass