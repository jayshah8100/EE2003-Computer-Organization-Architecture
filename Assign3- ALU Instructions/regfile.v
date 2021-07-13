module regfile(
    input [4:0] rs1,     // address of first operand to read - 5 bits
    input [4:0] rs2,     // address of second operand
    input [4:0] rd,      // address of value to write
    input we,            // should write update occur
    input [31:0] wdata,  // value to be written
    output reg [31:0] rv1,   // First read value
    output reg [31:0] rv2,   // Second read value
    input clk            // Clock signal - all changes at clock posedge
);

    reg[31:0] memarr [31:0]; // This array stores all the 32 registers of the regfile
    integer i;

    initial begin
        for(i=0;i<32;i=i+1)
            memarr[i]<=0;       // Initialzing each reg to 0
    end

    always @(posedge clk or rs1 or rs2)begin
        if(we && rd!=0)     // reg[0] has to be hardwired to 0, rd cannot change it
            memarr[rd]<=wdata;
        rv2<=memarr[rs2];      
        rv1<=memarr[rs1];
    end

endmodule





// module regfile(
//     input [4:0] rs1,     // address of first operand to read - 5 bits
//     input [4:0] rs2,     // address of second operand
//     input [4:0] rd,      // address of value to write
//     input we,            // should write update occur
//     input [31:0] wdata,  // value to be written
//     output [31:0] rv1,   // First read value
//     output [31:0] rv2,   // Second read value
//     input clk            // Clock signal - all changes at clock posedge
// );
//     // Desired function
//     // rv1, rv2 are combinational outputs - they will update whenever rs1, rs2 change
//     // on clock edge, if we=1, regfile entry for rd will be updated

//     assign rv1 = 'h12345678;
//     assign rv2 = 'h87654321;


// endmodule