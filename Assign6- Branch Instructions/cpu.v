module cpu (
    input clk, 
    input reset,
    input [31:0] idata,          // data from imem
    output reg [31:0] iaddr,     // address to imem

    input [31:0] drdata,        // data read from dmem
    output reg [31:0] daddr,    // address to dmem
    output reg [31:0] dwdata,   // data to be written to dmem
    output reg [3:0] dwe        // write enable signal for each byte of 4B word
);

    always @(posedge clk) begin
        if (reset) begin
            iaddr <= 0;
            daddr <= 0;
            dwdata <= 0;
            dwe <= 0;
            
        end else begin 
            iaddr <=PC_next;   
        end
    end

    wire [31:0] PC_next;
    wire [31:0] PC_4;



    wire [1:0] alusrc;
    wire memtoreg;
    wire regwrite;
    wire [3:0] memwrite;
    wire [2:0] branch;
    wire [1:0] aluop;
    wire [1:0] regin;
    wire [2:0] imm;

    //Control Unit

    control CTRL(
            .idata(idata), 
            .alusrc(alusrc),
            .memtoreg(memtoreg),
            .regwrite(regwrite),
            .memwrite(memwrite),
            .branch(branch),
            .aluop(aluop),
            .regin(regin),
            .imm(imm)
            );
            
 
    reg [31:0] regindata;
    wire [31:0] data1;
    wire [31:0] data2;

    // Register File

    regfile RF(
            .reset(reset),
            .rs1(idata[19:15]),
            .rs2(idata[24:20]),
            .rd(idata[11:7]),
            .indata(regindata),
            .we(regwrite),
            .clk(clk),
            .rv1(data1),
            .rv2(data2)
        );




    // ALU_CONTROL

    wire [3:0] op; //alu_op

    alucontrol ALUCTRL(
            .aluop(aluop),
            .instr(idata),
            .funct3(idata[14:12]),
            .op(op)   
    );




    //ALU

    wire [31:0] aluout;
    wire zero;
    
    wire [31:0] in2;
    assign in2 = alusrc[1] ? immgen : data2;

    wire [31:0] in1;
    assign in1 = alusrc[0] ? iaddr : data1;

    alu ALU(
            .in1(in1),
            .in2(in2),
            .op(op),
            .out(aluout),
            .zero(zero)
            );




    
    // Offset calculation

    wire [31:0] immgen;         // offset

    immgen IMMGEN(
            .imm(imm),
            .idata(idata),
            .immgen(immgen)
            );






    // To handle SW, SH, SB

    always @(*) begin
        if (memwrite == 4'b1111 && daddr[1:0]== 2'b00) dwe = 4'b1111;
        else if (memwrite == 4'b0011 && daddr[1:0]== 2'b00) dwe=4'b0011;
        else if (memwrite == 4'b0011 && daddr[1:0]== 2'b10) dwe=4'b1100;
        else if (memwrite == 4'b0001 && daddr[1:0]== 2'b00) dwe=4'b0001;
        else if (memwrite == 4'b0001 && daddr[1:0]== 2'b01) dwe=4'b0010;
        else if (memwrite == 4'b0001 && daddr[1:0]== 2'b10) dwe=4'b0100;
        else if (memwrite == 4'b0001 && daddr[1:0]== 2'b11) dwe=4'b1000;
        else dwe=4'b0000; 
    end


    always @(*) begin
        if (memwrite == 4'b0000) dwdata= data2;
        else dwdata= (data2 << (daddr[1:0] * 8));
    end

    always @(*) begin
        if (imm= 3'b010 || imm==3'b000)begin
            daddr= aluout;
        end
    end
    





    // To handle LW, LH, LB

    wire [31:0] memdata;
    reg [31:0] mem_to_regdata;

    assign memdata = memtoreg ? drdata : aluout;
    
    wire [15:0] LHdata; //since LH & LHU type instr. have to be dealt with differently
    wire [7:0] LBdata; //LH/LB type have to be sign extended while  LHU/LBU are just 0 padded
    
    assign LHdata=((memdata >> (daddr[1:0] * 8)) & 32'h0000FFFF);
    assign LBdata=((memdata >> (daddr[1:0] * 8)) & 32'h000000FF);


    always @(*) begin
        if (memtoreg && (idata[14:12] == 3'b001)) mem_to_regdata= {{16{memdata[(daddr[1:0] * 8) + 15]}},LHdata};  //LH instr.-The HW is sign extended after masking
        else if (memtoreg && (idata[14:12] == 3'b101)) mem_to_regdata= LHdata;  //LHU instr.- HW is 0 padded, just masking is enough
        else if (memtoreg && (idata[14:12] == 3'b000)) mem_to_regdata= {{24{memdata[(daddr[1:0] * 8) +7]}},LBdata};  //LB instr.-The LB is sign extended after masking
        else if (memtoreg && (idata[14:12] == 3'b100)) mem_to_regdata= LBdata; //LBU instr.
        else mem_to_regdata=memdata;       //LW,etc
    end

    always @(*) begin
        if  (regin == 2'b00) regindata= mem_to_regdata;
        else if (regin == 2'b01) regindata= immgen;
        else if  (regin == 2'b10) regindata= PC_4;
        else regindata= mem_to_regdata;
    end




    
    // To calculate next iaddr


    pc Prog_Counter(
        .PC(iaddr),
		.immgen(immgen),
		.branch(branch),
		.zero(zero),
		.aluout(aluout),
		.PC_4(PC_4),
		.PC_next(PC_next)
		);


endmodule

// module cpu (
//     input clk, 
//     input reset,
//     output [31:0] iaddr,
//     input [31:0] idata,
//     output [31:0] daddr,
//     input [31:0] drdata,
//     output [31:0] dwdata,
//     output [3:0] dwe
// );
//     reg [31:0] iaddr;
//     reg [31:0] daddr;
//     reg [31:0] dwdata;
//     reg [3:0]  dwe;

//     always @(posedge clk) begin
//         if (reset) begin
//             iaddr <= 0;
//             daddr <= 0;
//             dwdata <= 0;
//             dwe <= 0;
//         end else begin 
//             iaddr <= iaddr + 1;
//         end
//     end

// endmodule