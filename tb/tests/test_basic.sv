class test_basic extends uvm_test;

    timer_env env;

    `uvm_component_utils(test_basic)

    function new(string name="test_basic", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        env = timer_env::type_id::create("env", this);
    endfunction

    task run_phase(uvm_phase phase);
        basic_read_write_seq seq = basic_read_write_seq::type_id::create("seq");
        seq.start(env.agent.sqr);
    endtask

endclass
