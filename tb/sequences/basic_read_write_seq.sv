class basic_read_write_seq extends uvm_sequence #(axi_seq_item);

    `uvm_object_utils(basic_read_write_seq)

    function new(string name = "basic_read_write_seq");
        super.new(name);
    endfunction

    task body();
        axi_seq_item tr;

        // -----------------------------------------------------
        // Simple WRITE: CTRL register @ 0x0, write 1
        // -----------------------------------------------------
        tr = axi_seq_item::type_id::create("wr_tr");

        tr.is_write = 1;
        tr.addr     = 4'h0;       // CTRL register
        tr.wdata    = 32'h1;      // START = 1

        start_item(tr);
        finish_item(tr);

        // -----------------------------------------------------
        // Simple READ: COUNT register @ 0x8
        // -----------------------------------------------------
        tr = axi_seq_item::type_id::create("rd_tr");

        tr.is_write = 0;
        tr.addr     = 4'h8;       // COUNT register

        start_item(tr);
        finish_item(tr);
    endtask

endclass
