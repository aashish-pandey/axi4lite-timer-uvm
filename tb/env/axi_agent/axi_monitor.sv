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

    //main sampling logic

    task run_phase(uvm_phase phase);
        
        forever begin
            @(posedge vif.ACLK);

            //sample write transaction
            if(vif.AWVALID && vif.AWREADY)
                capture_write_addr();

            if(vif.WVALID && vif.WREADY)
                capture_write_data();
            if(vif.BVALID && vif.BREADY)
                finalize_write();

            //sample read transaction
            if(vif.ARVALID && vif.ARREADY)
                capture_read_addr();
            if(vif.RVALID && vif.RREADY)
                finalize_read();
        end
        
    endtask

    //internal state variables
    axi_seq_item wr_item;
    axi_Seq_item rd_item;

    //capture write address channel (AW)
    task capture_write_addr();
        wr_item = axi_seq_item::type_id::create("wr_item");
        wr_item.is_write = 1;
        wr_item.addr = vif.AWADDR;

        `uvm_info("AXI_MON", 
                $sformatf("MON WRITE ADDR: 0x%0h", wr_item.addr), 
                UVM_LOW)
    endtask 

    //capture write data channel (W)
    task capture_write_data();
        if(wr_item == null)
            wr_item = axi_seq_item::type_id::create("wr_item");
        
        wr_item.wdata = vif.WDATA;

        `uvm_info("AXI_MON", 
                    $sformatf("MON WRITE DATA: 0x%0h", wr_item.wdata). 
                    UVM_LOW)
    endtask 


    //finalize write
    task finalize_write();
        
        if(wr_item == null)begin
            `uvm_warning("AXI_MON", "Write response seen without write transaction")
            return;
        end

        `uvm_info("AXI_MON",
                    $sformatf("MON WRITE COMPLETE addr = 0x%0h data =0x%0h",
                    wr_item.addr, wr_item.wdata),
                    UVM_MEDIUM)
        ap.write(wr_item)
        wr_item = null;
    endtask

    //capture read address channel (AR)

    task capture_read_addr();
        rd_item = axi_Seq_item::type_id::create("rd_item");
        rd_item.is_write = 0;
        rd_item.addr = vif.ARADDR;

        `uvm_info("AXI_MON", 
                    $sformatf("MON READ ADDR: 0c%0h", rd_item.addr), 
                    UVM_LOW)
    endtask

    //finalize read (on RVALID/RREADY)
    task finalize_read();
        if(rd_item == null)begin
            `uvm_warning("AXI_MON", "Read response seen without read request")
            return;
        end

        rd_item.rdata = vif.RDATA;

        `uvm_info("AXI_MON", 
                    $sformatf("MON READ DATA: addr = 0x%0h data = 0x%0h", 
                    rd_item.addr, rd_item.rdata),
                    UVM_MEDIUM)
        ap.write(rd_item);
        rd_item = null;

    endtask


endclass