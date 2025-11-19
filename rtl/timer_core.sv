module timer_core(
    input logic clk, 
    input logic rstn, 

    input logic start, 
    input logic stop, 
    input logic [31:0] load_val,

    output logic [31:0] cur_count,
    output logic irq 
);

logic running;

always_ff @(posedge clk or negedge rstn) begin
    if(!rstn) begin
        cur_count <= 0;
        running <= 0;
        irq <= 0;
    end
    else begin
        //start or stop
        if(start) running <= 1;
        if(stop) running <= 0;

        if(running) begin
            cur_count <= cur_count + 1;

            if(cur_count == 32'hFFFF_FFFF)begin
                irq <= 1;
                cur_count <= load_val; //reload
            end
        end
    end
end
endmodule