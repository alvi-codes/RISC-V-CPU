module reg_file #(
    parameter ADDRESS_WIDTH = 32,
    parameter DATA_WIDTH = 32
   // parameter REGISTER_WIDTH = 32
) (
    input  logic                             clk,
    input  logic                             WE3,
    input  logic     [ADDRESS_WIDTH-1:0]     AD1,
    input  logic     [ADDRESS_WIDTH-1:0]     AD2,
    input  logic     [ADDRESS_WIDTH-1:0]     AD3,
    input  logic     [DATA_WIDTH-1:0]        WD3,
    output logic     [DATA_WIDTH-1:0]        RD1,
    output logic     [DATA_WIDTH-1:0]        RD2, 
    output logic     [DATA_WIDTH-1:0]        a0,
    output logic     [DATA_WIDTH-1:0]        a1,
    output logic     [DATA_WIDTH-1:0]        a2,
    output logic     [DATA_WIDTH-1:0]        a3,
    output logic     [DATA_WIDTH-1:0]        a4,
    output logic     [DATA_WIDTH-1:0]        a5,
    output logic     [DATA_WIDTH-1:0]        a6,
    output logic     [DATA_WIDTH-1:0]        t0,
    output logic     [DATA_WIDTH-1:0]        t1  
);

    //logic   [REGISTER_WIDTH-1:0]     regfile     [REGISTER_WIDTH-1:0]; // figuring out how to load regfile with initial values

    logic [DATA_WIDTH-1:0] regfile [2**ADDRESS_WIDTH-1:0];

    // initial begin
    //     $readmemh("testrom.mem", regfile); // remove when merge; prove of workability
    // end;

    always_ff @ (posedge clk) begin
        if (WE3 == 1'b1) // if WRITE Enable, feed WD3 into AD3 Register
            regfile [AD3] <= WD3;
    end

    assign RD1 = regfile [AD1]; // RD1 outputs the AD1 Register value
    assign RD2 = regfile [AD2];  // as above
    assign a0 = regfile [10]; // a0 refers to register x10 in RISC-V instruction set. using to debug
    assign a1 = regfile [11]; // a0 refers to register x10 in RISC-V instruction set. using to debug
    assign a2 = regfile [12]; // a0 refers to register x10 in RISC-V instruction set. using to debug
    assign a3 = regfile [13]; // a0 refers to register x10 in RISC-V instruction set. using to debug
    assign a4 = regfile [14]; // a0 refers to register x10 in RISC-V instruction set. using to debug
    assign a5 = regfile [15]; // a0 refers to register x10 in RISC-V instruction set. using to debug
    assign a6 = regfile [16]; // a0 refers to register x10 in RISC-V instruction set. using to debug
    assign t0 = regfile [5];
    assign t1 = regfile [6];
    
endmodule
