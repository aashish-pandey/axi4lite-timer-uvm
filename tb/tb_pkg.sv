package tb_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    // ---------------------------------------------------------
    // AXI4-Lite Agent Components
    // ---------------------------------------------------------
    `include "./env/axi_agent/axi_seq_item.sv"
    `include "./env/axi_agent/axi_sequencer.sv"
    `include "./env/axi_agent/axi_driver.sv"
    `include "./env/axi_agent/axi_monitor.sv"
    `include "./env/axi_agent/axi_agent.sv"

    // ---------------------------------------------------------
    // Timer Environment Components
    // ---------------------------------------------------------
    `include "./env/timer_scoreboard.sv"
    `include "./env/timer_cov.sv"
    `include "./env/timer_env.sv"

    // ---------------------------------------------------------
    // Sequences
    // ---------------------------------------------------------
    `include "./sequences/basic_read_write_seq.sv"
    // `include "./sequences/random_access_seq.sv"

    // ---------------------------------------------------------
    // Tests
    // ---------------------------------------------------------
    `include "./tests/test_basic.sv"
    // `include "./tests/test_random.sv"

endpackage
