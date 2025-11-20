module top_tb;

    import uvm_pkg::*;
    import tb_pkg::*;

    logic ACLK;
    logic ARESETn;

    // Clock generation
    initial begin
        ACLK = 0;
        forever #5 ACLK = ~ACLK;  // 100 MHz
    end

    // Reset generation
    initial begin
        ARESETn = 0;
        #50;
        ARESETn = 1;
    end

    // DUT interface
    axi4lite_if axi_if(ACLK, ARESETn);

    // DUT instantiation
    top_timer dut (
        .ACLK     (ACLK),
        .ARESETn  (ARESETn),
        .axi      (axi_if)
    );

    // Start UVM test
    initial begin
        // Pass VIF to test (not directly to agent)
        uvm_config_db#(virtual axi4lite_if)::set(null,
                                                 "uvm_test_top.env",
                                                 "vif",
                                                 axi_if);

        run_test("test_basic");
    end

endmodule
