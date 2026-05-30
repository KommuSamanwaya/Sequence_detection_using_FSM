module seq_dett_tb();

reg seq_in, clk, reset;
wire det_out;

parameter CYCLE = 10;

// DUT Instantiation


seq_dett DUT(
    .seq_in(seq_in),
    .clk(clk),
    .reset(reset),
    .det_out(det_out)
);

// Step1 : Clock Generation

initial
begin
    clk = 0;

    forever #(CYCLE/2) clk = ~clk;
end

// Step2 : Task for Initialization

task initialize;
begin
    seq_in = 0;
end
endtask

//delay task 

task delay(input integer value);
begin
    #value;
end
endtask

// Step3 : Reset Task

task RESET;
begin
    reset = 1;
    delay(10);

    reset = 0;
end
endtask

// Step4 : Stimulus Task
// Input applied at negative edge of clock

task stimulus(input data);
begin
    @(negedge clk)
    seq_in = data;
end
endtask

initial
begin
    $monitor("Time=%0t Reset=%b Present_State=%b Input=%b Output=%b",
              $time, reset, DUT.present_state, seq_in, det_out);
end

always @(DUT.present_state or det_out)
begin

    if(det_out == 1)
        $display("Sequence Detected at Time = %0t", $time);

end

// Step5 : Applying Input Sequence
// Overlapping Sequence Detection

initial
begin

    initialize;

    RESET;

    // Input Sequence : 110101101011

    stimulus(1);
    stimulus(1);
    stimulus(0);

    stimulus(1);
    stimulus(0);
    stimulus(1);
    stimulus(1);

    stimulus(0);

    stimulus(1);
    stimulus(0);
    stimulus(1);
    stimulus(1);

    delay(20);

    $finish;

end
endmodule
