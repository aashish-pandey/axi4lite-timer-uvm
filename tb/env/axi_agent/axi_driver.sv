class axi_driver extends uvm_driver #(axi_seq_item);

    virtual axi4lite_if vif;

    `uvm_component_utils(axi_driver)

    function new(string name="axi_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual axi4lite_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "No virtual interface provided for axi_driver")
    endfunction


    // ---------------------------------------------------------
    // RUN PHASE  (FIXED — semicolon added + begin/end)
    // ---------------------------------------------------------
    task run_phase(uvm_phase phase);
        forever begin
            axi_seq_item req;
            seq_item_port.get_next_item(req);

            if (req.is_write)
                send_write(req);
            else
                send_read(req);

            seq_item_port.item_done();
        end
    endtask


    // ---------------------------------------------------------
    // WRITE TRANSACTION
    // ---------------------------------------------------------
    task send_write(axi_seq_item req);

        `uvm_info("AXI_DRV",
                  $sformatf("WRITE: addr=0x%0h data=0x%0h",
                            req.addr, req.wdata),
                  UVM_MEDIUM)

        // Address channel
        vif.AWADDR  <= req.addr;
        vif.AWVALID <= 1;

        @(posedge vif.ACLK);
        wait (vif.AWREADY);

        vif.AWVALID <= 0;

        // Data channel
        vif.WDATA  <= req.wdata;
        vif.WSTRB  <= 4'hF;
        vif.WVALID <= 1;

        @(posedge vif.ACLK);
        wait (vif.WREADY);

        vif.WVALID <= 0;

        // Write response
        vif.BREADY <= 1;

        @(posedge vif.ACLK);
        wait (vif.BVALID);

        if (vif.BRESP != 0)
            `uvm_error("AXI_WRITE", "BRESP not OKAY")

        vif.BREADY <= 0;

    endtask


    // ---------------------------------------------------------
    // READ TRANSACTION
    // ---------------------------------------------------------
    task send_read(axi_seq_item req);

        `uvm_info("AXI_DRV",
                  $sformatf("READ: addr=0x%0h", req.addr),
                  UVM_MEDIUM)

        // Address channel
        vif.ARADDR  <= req.addr;
        vif.ARVALID <= 1;

        @(posedge vif.ACLK);
        wait (vif.ARREADY);

        vif.ARVALID <= 0;

        // Data return
        vif.RREADY <= 1;

        @(posedge vif.ACLK);
        wait (vif.RVALID);

        req.rdata = vif.RDATA;

        `uvm_info("AXI_DRV",
                  $sformatf("READ DATA @0x%0h = 0x%0h",
                             req.addr, req.rdata),
                  UVM_LOW)

        if (vif.RRESP != 0)
            `uvm_error("AXI_READ", "RRESP not OKAY")

        vif.RREADY <= 0;

    endtask

endclass
