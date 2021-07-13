module dummydecoder(
    input [31:0] instr,  // Full 32-b instruction
    output reg [5:0] op,     // some operation encoding of your choice
    output reg [4:0] rs1,    // First operand
    output reg [4:0] rs2,    // Second operand
    output reg [4:0] rd,     // Output reg
    input  [31:0] r_rv2, // From RegFile
    output reg [31:0] rv2,   // To ALU
    output we            // Write to reg
);
    //Opcodes have been given in the order they appear in the risc-spec manual for the RV32I Base Instr. Set
    //eg. opcode 18 corresponds to the 18 instr. from the table
    
    always @(instr or r_rv2) begin
        case(instr[6:0])  // checks whether its a Reg-Immediate Instr(I type)
            7'b0010011:begin
                rd<=instr[11:7];
                rs1<=instr[19:15];
                rs2<=instr[24:20];
                rv2<=instr[31:20];  // rv2-> last 12 bits of instr.
                case(instr[14:12])
                    3'b000: op <= 18;
					3'b010: op <= 19;
					3'b011: op <= 20;
					3'b100: op <= 21;
					3'b110: op <= 22;
					3'b111: op <= 23;
					3'b001: op <= 24;
					3'b101: 
						case(instr[30])
							1'b0: op = 25;
							1'b1: op = 26;		
						endcase
				endcase
            end
            7'b0110011:begin  // checks whether its a Reg-Reg Instr(R type)
                rd<=instr[11:7];
                rs1<=instr[19:15];
                rs2<=instr[24:20];
                rv2<=r_rv2;  // rv2-> is looked up from memarr in regfile.v
				case(instr[14:12])
					3'b000: 
						case(instr[30])
							1'b0: op <= 27;
							1'b1: op <= 28;	
						endcase
					3'b001: op <= 29;
					3'b010: op <= 30;
					3'b011: op <= 31;
					3'b100: op <= 32;
					3'b101: 
						case(instr[30])
							1'b0: op <= 33;
							1'b1: op <= 34;	
						endcase
					3'b110: op <= 35;
					3'b111: op <= 36;
				endcase
            end
        endcase
    end      
    assign we = 1;      // For only ALU ops, can always set to 1
    

endmodule



// module dummydecoder(
//     input [31:0] instr,  // Full 32-b instruction
//     output [5:0] op,     // some operation encoding of your choice
//     output [4:0] rs1,    // First operand
//     output [4:0] rs2,    // Second operand
//     output [4:0] rd,     // Output reg
//     input  [31:0] r_rv2, // From RegFile
//     output [31:0] rv2,   // To ALU
//     output we            // Write to reg
// );

//     assign op = 'h0;
//     assign rs1 = 'h0;
//     assign rs2 = 'h0;
//     assign rd = 'h0;
//     assign we = 1;      // For only ALU ops, can always set to 1
//     assign rv2 = 'h0;   // Should send either the value from the RegFile or the Imm value from Instr

// endmodule

