class timer_env extends uvm_env;
    
    axi_agent agent;
    timer_scoreboard sb;
    timer_cov cov;

    `uvm_component_utils(timer_env)

    function new(string name = "timer_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase):
        super.build_phase(phase);

        agent = axi_agent::type_id::create("agent", this);
        sb = timer_scoreboard::type_id::create("sb", this);
        cov = timer_cov::type_id::create("cov", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        agent.mon.ap.connect(sb.monitor_ap);

        agent.mon.ap.connect(cov.monitor_ap);
    endfunction
    

endclass