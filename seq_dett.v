module seq_dett(
    seq_in,
    clk,
    reset,
    det_out
);

// Step1 : Declare the states as parameters

parameter S0   = 3'b000,
          S1   = 3'b001,
          S2  = 3'b010,
          S3  = 3'b011,
          S4 = 3'b100;

// Step2 : Declare input and output ports

input seq_in, clk, reset;
output det_out;

// Internal Registers

reg [2:0] present_state, next_state;

// Step3 : Sequential Logic
// Present State Logic with Active High Asynchronous Reset


always @(posedge clk or posedge reset)
begin
    if(reset)
        present_state <= S0;
    else
        present_state <= next_state;
end

// Step4 : Combinational Logic
// Next State Logic

always @(*)
begin

    case(present_state)

        S0 :
        begin
            if(seq_in == 1)
                next_state = S1;
            else
                next_state = S0;
        end

        S1 :
        begin
            if(seq_in == 1)
                next_state = S2;
            else
                next_state = S3;
        end

        S2 :
        begin
            if(seq_in == 1)
                next_state = S2;
            else
                next_state = S3;
        end

        S3 :
        begin
            if(seq_in == 1)
                next_state = S4;
            else
                next_state = S0;
        end

        S4 :
        begin
            if(seq_in == 1)
                next_state = S2;
            else
                next_state = S3;
        end

        default :
            next_state = S0;

    endcase

end

// Step5 : Continuous Assignment Output Logic

assign det_out = ((present_state == S2)  && (seq_in == 0)) ||
                 ((present_state == S4) && (seq_in == 1));

endmodule
