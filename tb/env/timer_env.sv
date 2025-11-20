class timer_env extends uvm_env;

    // Components
    axi_agent       agent;
    timer_scoreboard sb;
    timer_cov       cov;

    // Virtual interface (set from test)
    virtual axi4lite_if vif;

    `uvm_component_utils(timer_env)

    function new(string name = "timer_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction


    // ---------------------------------------------------------
    // Build Phase
    // ---------------------------------------------------------
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        agent = axi_agent::type_id::create("agent", this);
        sb    = timer_scoreboard::type_id::create("sb", this);
        cov   = timer_cov::type_id::create("cov", this);

        // Pass VIF to agent + monitor + driver proxy
        if(!uvm_config_db#(virtual axi4lite_if)::get(this, "", "vif", vif))
            `uvm_fatal("NOVIF", "timer_env: No VIF provided")

        uvm_config_db#(virtual axi4lite_if)::set(this, "agent*", "vif", vif);
    endfunction


    // ---------------------------------------------------------
    // Connect Phase
    // ---------------------------------------------------------
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        // Agent monitor → scoreboard
        agent.mon.ap.connect(sb.monitor_ap);

        // Agent monitor → coverage
        agent.mon.ap.connect(cov.monitor_ap);
    endfunction

endclass
