module fsm_controller (
    input clk,
    input rst_n,
    input start,
    output reg load_en,    // Tells memory to send data
    output reg compute_en, // Tells Mohana to start MAC
    output reg [1:0] state_out
);

    parameter IDLE    = 2'b00;
    parameter LOAD    = 2'b01;
    parameter COMPUTE = 2'b10;
    parameter DONE    = 2'b11;

    reg [1:0] current_state, next_state;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) current_state <= IDLE;
        else        current_state <= next_state;
    end

    always @(*) begin
        case (current_state)
            IDLE:    next_state = (start) ? LOAD : IDLE;
            LOAD:    next_state = COMPUTE;
            COMPUTE: next_state = DONE;
            DONE:    next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // NEW: Logic to turn on/off the "Enable" signals
    always @(*) begin
        state_out = current_state;
        load_en    = (current_state == LOAD);    // ON only during LOAD
        compute_en = (current_state == COMPUTE); // ON only during COMPUTE
    end

endmodule