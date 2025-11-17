class basic_read_write_seq extends uvm_sequence #(axi_seq_item);

    `uvm_object_utils(basic_read_write_seq)

    function new(string name = "basic_read_write_seq");
        super.new(name);
    endfunction

    task body();
        axi_seq_item tr;

        //simple write
        tr = axi_seq_item::type_id::create("tr");
        tr.is_written = 1;
        tr.adder = 4'h0;
        tr.wdata = 32'h1;
        
        start_item(tr);
        finish_item(tr);

        //simple read
        tr = axi_seq_item::type_id::create("tr2");
        tr.is_write = 0;
        tr.addr = 4'h8;
        start_item(tr);
        finish_item(tr);
    endtask

endclass
