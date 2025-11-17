package tb_pkg;

import uvm_pkg::*;
`include "uvm_macros.svh"

//AXI components
`include "axi_seq_item.sv"
`include "axi_sequencer.sv"
`include "axi_driver.sv"
`include "axi_monitor.sv"
`include "axi_agent.sv"

//Environment components
`include "timer_scoreboard.sv"
`include "timer_cov.sv"
`include "timer_env.sv"

//sequences
`include "basic_read_write_seq.sv"
`include "random_access_seq.sv"


//Tests
`include "test_basic.sv"
`include "test_random.sv"

endpackage