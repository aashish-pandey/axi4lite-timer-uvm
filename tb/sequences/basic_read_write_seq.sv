class basic_read_write_seq extends uvm_sequence #(axi_seq_item);

    `uvm_object_utils(basic_read_write_seq)

    function new(string name = "basic_read_write_seq");
        super.new(name);
    endfunction

    task body();
        axi_seq_item tr;

        // -------------------------
        // WRITE CTRL = 1
        // -------------------------
        tr = axi_seq_item::type_id::create("wr_ctrl");
        tr.is_write = 1;
        tr.addr     = 4'h0;
        tr.wdata    = 32'h1;

        start_item(tr);
        finish_item(tr);

        // -------------------------
        // READ COUNT register
        // -------------------------
        tr = axi_seq_item::type_id::create("rd_count");
        tr.is_write = 0;
        tr.addr     = 4'h8;

        start_item(tr);
        finish_item(tr);

    endtask
endclass
