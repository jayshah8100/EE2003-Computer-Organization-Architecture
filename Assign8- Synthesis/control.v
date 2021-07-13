module control(
	
    input [31:0] idata,   //instr.
    output [1:0] alusrc,        
    output memtoreg,
    output regwrite,
    output reg [3:0] memwrite,
    output reg [2:0] branch,
    output [1:0] aluop,
	output reg [1:0] regin,
	output reg  [2:0] imm     
    );
	 
    wire [6:0] opcode;
    wire [2:0] funct3;

    assign opcode = idata[6:0];
    assign funct3 = idata[14:12];

    always @(*) begin
        if (opcode == 7'b1100011 && (funct3 == 3'b000 ||  funct3 == 3'b101 || funct3 == 3'b111)) branch= 3'b010;  //BEQ, BGE, BGEU
        else if (opcode == 7'b1100011 && (funct3 == 3'b001 || funct3 == 3'b100 || funct3 == 3'b110)) branch= 3'b001; // BNE, BLT, BLTU
        else if (opcode == 7'b1101111 ) branch= 3'b011; // JAL
        else if (opcode == 7'b1100111 ) branch= 3'b100; // JALR
        else branch= 3'b000; //Non-branching instr.
    end

    // contols whther the data to be written into regfile is from alu ( R-ALUI type instr.) or dmem ( drdata) in case of load instr.
    assign memtoreg = (opcode == 7'b0000011); // is asserted only in the case of load instr
 
    
    
    // memwrite controls the dwe of dmem in the case of store instr.
    always @(*)begin
        if (opcode == 7'b0100011 && funct3 == 3'b010) memwrite= 4'b1111;         //SW
        else if (opcode == 7'b0100011 && funct3 == 3'b001) memwrite= 4'b0011;    //SH
        else if (opcode == 7'b0100011 && funct3 == 3'b000) memwrite= 4'b0001;    //SB
        else memwrite= 4'b0000;
    end                   

    
    
    // regwrite is nothing but the write enable signal of the regfile
    assign regwrite=(opcode == 7'b0110011 || opcode == 7'b0000011 || opcode == 7'b0010011 || opcode == 7'b1101111 || opcode == 7'b1100111 || opcode == 7'b0010111 || opcode == 7'b0110111);            // asserted only for ALU (R-I), Load, JAL,JALR, LUI, AUIPC instr.


    
    // alusrc controls what 2 operands in1 & in2 go into the alu
    assign alusrc[1] = (opcode == 7'b0100011 || opcode == 7'b0000011 || opcode == 7'b0010011 || opcode == 7'b0010111 || opcode == 7'b1100111);  //controls in2- is asserted in all I type (JALR,ALUI,Load) instr. & Store instr.
    assign alusrc[0] = (opcode == 7'b0010111); // controls in1- only asserted in case of AUIPC instr. where rs1=PC & rs2=immgen 
    
    
    
    // aluop is just another differentating signal used to simplify the opcode allocation process in alucontrol.v module    
    assign aluop[1] = (opcode == 7'b0110011 || opcode == 7'b0010011 ); // aluop=2'b 10 for all usual ALU(i.e R and ALU-I) type instr.
    assign aluop[0] = (opcode == 7'b1100011);                          // aluop=2'b01 for all branch instr.
    
    // For rest all instr. aluop=2'b00 ( eg-load-store,jalr where simple addition has to take place)

    
    
    // regin controls what is written into regfile
    always @(*) begin      
        if (opcode == 7'b0110111) regin= 2'b01;                                // immgen value is placed in rd in case of LUI instr.
        else if (opcode == 7'b1101111 || opcode == 7'b1100111) regin = 2'b10; // JAL,JALR instr. regin is PC + 4 due to linking
        else regin= 2'b00;                                                    // In all other cases regin comes from mem_to regdata
    end

    
    
    // imm uniquely indentifies each instr. type - used in immgen module
    always @(*)begin     
        if (opcode == 7'b0110111 || opcode == 7'b0010111) imm= 3'b001;     // U type instr.
        else if (opcode == 7'b0100011) imm= 3'b010;                        //S type instr.
        else if (opcode == 7'b1101111) imm= 3'b011;                        //J type JAL instr.
        else if (opcode == 7'b1100011) imm= 3'b100;                        //B type instr.
        else imm=3'b000;                                                   // I type ( Load, ALUI, JALR) instr. 
    end

 endmodule

