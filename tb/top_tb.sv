module top_tb;

    import uvm_pkg::*;
    import tb_pkg::*;

    logic ACLK;
    logic ARESETn;

    //Clock
    initial begin
        ACLK = 0;
        forever #5 ACLK = ~ACLK;
    end

    //RESET
    initial begin
        ARESETn = 0;
        #50;
        ARESETn = 1;
    end

    //DUT
    axi4lite_if axi_if(ACLK, ARESETn);

    top_timer dut (
        .ACLK(ACLK),
        .ARESETn(ARESETn),
        .axi(axi_if)
    );

    //pass VIF to TB
    initial begin
        uvm_config_db#(virtual axi4lite_if)::set(null, "uvm_test_top.env.agent.*", "vif", axi_if);
        run_test("test_basic");
    end