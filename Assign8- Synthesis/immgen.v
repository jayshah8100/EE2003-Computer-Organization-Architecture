module immgen(
    input [2:0] imm,
    input [31:0] idata,
    output reg [31:0] immgen
    );
	
	always @(*) begin
		if (imm == 3'b000) immgen= {{20{idata[31]}},idata[31:20]}; //I type instr.- Load,ALUI,JALR type instr. imm is sign extended
        else if  (imm == 3'b001) immgen= {idata[31:12],{12{1'b0}}};                                                    //U type-LUI AUIPC
		else if  (imm == 3'b010) immgen= {{20{idata[31]}},idata[31:25],idata[11:7]}; 									// S type instr.
        else if  (imm == 3'b011) immgen= {{12{idata[31]}}, idata[19:12], idata[20], idata[30:21], 1'b0}; 			   //J type JAL
        else if  (imm == 3'b100) immgen= {{20{idata[31]}},idata[7],idata[30:25],idata[11:8],1'b0}; 						//B type instr.
        else immgen= {{20{idata[31]}},idata[31:20]};              // default case just sign extended 
	end

						 

endmodule