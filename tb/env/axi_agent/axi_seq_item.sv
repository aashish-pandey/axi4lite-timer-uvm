class axi_seq_item extends uvm_sequence_item;

    rand bit        is_write;  // 1 = write, 0 = read
    rand bit [3:0]  addr;
    rand bit [31:0] wdata;
         bit [31:0] rdata;

    `uvm_object_utils_begin(axi_seq_item)
        `uvm_field_int(is_write, UVM_ALL_ON)
        `uvm_field_int(addr,     UVM_ALL_ON)
        `uvm_field_int(wdata,    UVM_ALL_ON)
        `uvm_field_int(rdata,    UVM_ALL_ON)
    `uvm_object_utils_end;

    function new(string name="axi_seq_item");
        super.new(name);
    endfunction

endclass
