module pc (
    input [31:0] PC,
    input [31:0] immgen,
    input [2:0] branch,
    input zero,
	input [31:0] aluout,
	output [31:0] PC_4,
    output reg [31:0] PC_next
    );
	 


    assign PC_4 = PC + 4;

    wire [31:0] PC_branch;
    assign PC_branch = PC + immgen;


    always@(*) begin
        if (branch == 3'b001 && (~zero)) PC_next= PC_branch; //BNE, BLT, BLTU
        else if  (branch == 3'b010 && zero ) PC_next= PC_branch; // BEQ, BGE, BGEU
        else if   (branch == 3'b011) PC_next= PC_branch;  // JAL
        else if  (branch == 3'b100) PC_next = (aluout & 32'hFFFFFFFE);// JALR
        else PC_next= PC_4;
    end

endmodule