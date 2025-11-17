class timer_env extends uvm_env;
    
    axi_agent agent;
    timer_scoreboard sb;
    timer_cov cov;

    `uvm_component_utils(timer_env)

    function new(string name = "timer_env", util_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase):
        agent = axi_agent::type_id::create("agent", this);
        sb = time_scoreboard::type_id::create("sb", this);
        cov = timer_cov::type_id::create("cov", this);
    endfunction

endclass