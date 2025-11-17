class timer_scoreboard extends uvm_component;
    `uvm_component_utils(timer_scoreboard)

    function new(string name="timer_scoreboard", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    //analysis exports will be added later
endclass