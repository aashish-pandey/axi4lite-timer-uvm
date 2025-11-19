package tb_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"

//AXI components
`include "./env/axi_agent/axi_seq_item.sv"
`include "./env/axi_agent/axi_sequencer.sv"
`include "./env/axi_agent/axi_driver.sv"
`include "./env/axi_agent/axi_monitor.sv"
`include "./env/axi_agent/axi_agent.sv"

//Environment components
`include "timer_scoreboard.sv"
`include "timer_cov.sv"
`include "timer_env.sv"

//sequences
`include "./sequences/basic_read_write_seq.sv"
// `include "random_access_seq.sv"


//Tests
`include "./tests/test_basic.sv"
// `include "test_random.sv"

endpackage