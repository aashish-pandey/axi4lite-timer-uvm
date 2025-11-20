class test_basic extends uvm_test;

    timer_env env;

    `uvm_component_utils(test_basic)

    function new(string name="test_basic", uvm_component parent = null);
        super.new(name, parent);
    endfunction


    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        env = timer_env::type_id::create("env", this);

        // Pass virtual interface to env + agent + driver + monitor
        uvm_config_db#(virtual axi4lite_if)::set(this,
                                                 "env",
                                                 "vif",
                                                 top_tb.vif);  // IMPORTANT
    endfunction


    task run_phase(uvm_phase phase);
        phase.raise_objection(this);

        basic_read_write_seq seq;
        seq = basic_read_write_seq::type_id::create("seq");

        `uvm_info("TEST", "Starting basic_read_write_seq", UVM_LOW)
        seq.start(env.agent.sqr);

        phase.drop_objection(this);
    endtask

endclass
