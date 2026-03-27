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
    // RUN PHASE
    // ---------------------------------------------------------
    task run_phase(uvm_phase phase);
        // Idle all outputs until reset deasserts
        vif.AWVALID <= 0;
        vif.WVALID  <= 0;
        vif.BREADY  <= 0;
        vif.ARVALID <= 0;
        vif.RREADY  <= 0;
        vif.AWADDR  <= 0;
        vif.WDATA   <= 0;
        vif.WSTRB   <= 0;
        vif.ARADDR  <= 0;

        @(posedge vif.ACLK);
        wait(vif.ARESETn === 1'b1);

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

        // Drive AW + W channels simultaneously
        vif.AWADDR  <= req.addr;
        vif.AWVALID <= 1;
        vif.WDATA   <= req.wdata;
        vif.WSTRB   <= 4'hF;
        vif.WVALID  <= 1;

        // Wait for DUT to accept both address and data
        do @(posedge vif.ACLK); while (!(vif.AWREADY && vif.WREADY));

        vif.AWVALID <= 0;
        vif.WVALID  <= 0;

        // Wait for BVALID before asserting BREADY
        do @(posedge vif.ACLK); while (!vif.BVALID);
        vif.BREADY <= 1;
        @(posedge vif.ACLK);
        vif.BREADY <= 0;

    endtask


    // ---------------------------------------------------------
    // READ TRANSACTION
    // ---------------------------------------------------------
    task send_read(axi_seq_item req);
        `uvm_info("AXI_DRV",
                  $sformatf("READ: addr=0x%0h", req.addr),
                  UVM_MEDIUM)

        vif.ARADDR  <= req.addr;
        vif.ARVALID <= 1;

        // Wait for DUT to accept the read address
        do @(posedge vif.ACLK); while (!vif.ARREADY);

        vif.ARVALID <= 0;
        vif.RREADY  <= 1;

        // Wait for DUT to return read data
        do @(posedge vif.ACLK); while (!vif.RVALID);

        req.rdata = vif.RDATA;

        `uvm_info("AXI_DRV",
                  $sformatf("READ DATA: addr=0x%0h data=0x%0h",
                    req.addr, req.rdata),
                  UVM_MEDIUM)

        vif.RREADY <= 0;

    endtask

endclass