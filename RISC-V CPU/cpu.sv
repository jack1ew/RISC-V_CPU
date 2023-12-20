module cpu (
  input reg clck,
  input reg rst_n,
  input reg [31:0] in,
  output reg [31:0] out
);
// Instruction memory portion
logic [31:0] inst_ram [4095:0];
//initial $readmemh("instmem.dat",inst_ram);
initial $readmemh("bin2dec.txt",inst_ram);
logic [11:0] PC_FETCH;
logic [11:0] PC_EX;
logic [31:0] instruction_EX;
logic [4:0] regdest_WB;
logic [31:0] A_EX, B_EX;
logic alusrc_EX;
logic [31:0] regdata2_EX;
logic hex_we_EX;
logic regwrite_WB,regwrite_EX;
logic [1:0] regsel_WB,regsel_EX;
logic [31:0] lui_val_WB;
logic [31:0] R_WB;
logic [31:0] R_EX;
logic [31:0] writedata_WB;
logic [3:0] aluop_EX;
logic [6:0] f7, op;
logic [2:0] f3;
logic [4:0] r1, r2, r_d;
logic [11:0] imm12;
logic [19:0] imm20;
logic [31:0] in_WB;
logic z;
logic [9:0] imm10_;
logic [7:0] imm8_;
logic [5:0] imm6_;
logic [3:0] imm4_;
logic imm_1_;
logic imm1_;
logic [11:0] branch_addr_EX;
logic [12:0] branch_offset_EX;
logic [11:0] jalr_addr_EX;
logic [11:0] jalr_offset_EX;
logic [11:0] jal_addr_EX;
logic [20:0] jal_offset_EX;
logic [1:0] pcsrc_EX;
logic stall_WB;
logic take_branch;
logic zero_comp;
logic imm_;
always_ff @(posedge clck)
  if (~rst_n) begin
    PC_FETCH <= 12'b0;
    instruction_EX <= 32'b0;
  end else if (take_branch) begin
    $display("BRANCH YOU FOOL");
    PC_FETCH <= branch_addr_EX;
    instruction_EX <= inst_ram[PC_FETCH];
    //pcsrc_EX <= 2'b00;
  end else if (pcsrc_EX == 2'b10) begin
    PC_FETCH <= jal_addr_EX;
    instruction_EX <= inst_ram[PC_FETCH];
    //pcsrc_EX <= 2'b00;
  end else if (pcsrc_EX == 2'b11) begin
    PC_FETCH <= jalr_addr_EX;
    instruction_EX <= inst_ram[PC_FETCH];
    //pcsrc_EX <= 2'b00;
  end else begin
    PC_FETCH <= PC_FETCH + 1'b1;
    instruction_EX <= inst_ram[PC_FETCH];
  end

always_ff @(posedge clck) begin
  PC_EX <= PC_FETCH;
  $display("%h %h %h %h %h %h", PC_EX, instruction_EX, stall_WB, regwrite_EX, regwrite_WB, writedata_WB);
  if (PC_FETCH > 12'd24) begin
  	//$finish;
  end
  regdest_WB <= instruction_EX[11:7];
  if (take_branch == 1 || pcsrc_EX == 2'b10 || pcsrc_EX == 2'b11) begin
    stall_WB <= 1;
  end else
    stall_WB <= 0;
  if (hex_we_EX) out <= A_EX;
  //$display("%h", out);
  regwrite_WB <= stall_WB == 1'b0 ? regwrite_EX : 1'b0;
  regsel_WB <= regsel_EX;
  in_WB <= in;
  lui_val_WB <= {instruction_EX[31:12], 12'b0};
  R_WB <= R_EX;
end

assign take_branch = (pcsrc_EX == 2'b01) && (z == zero_comp) && (stall_WB == 0);

assign B_EX = alusrc_EX == 1'b0 ? regdata2_EX : {{20{instruction_EX[31]}}, instruction_EX[31:20]};

assign writedata_WB = regsel_WB == 2'b00 ? in_WB : regsel_WB == 2'b01 ? lui_val_WB : regsel_WB == 2'b10 ? R_WB : {18'b0,PC_EX,2'b0};

decode dc(.instructaddr(instruction_EX), .funct7(f7), .rs2(r2), .rs1(r1), .funct3(f3), .rd(r_d),
          .opcode(op), .imm20(imm20), .imm12(imm12), .imm10(imm10_), .imm8(imm8_), .imm6(imm6_),
          .imm4(imm4_), .imm_1(imm_1_), .imm1(imm1_), .imm(imm_));

assign branch_offset_EX = {instruction_EX[31], instruction_EX[7], instruction_EX[30:25],
                           instruction_EX[11:8], 1'b0};

assign branch_addr_EX = PC_EX + {branch_offset_EX[12], branch_offset_EX[12:2]};

assign jal_offset_EX = {instruction_EX[31],instruction_EX[19:12],instruction_EX[20],instruction_EX[30:21],1'b0};

assign jal_addr_EX = PC_EX + jal_offset_EX[13:2];

assign jalr_offset_EX = instruction_EX[31:20];

assign jalr_addr_EX = A_EX[13:2] + {{2{jalr_offset_EX[11]}},jalr_offset_EX[11:2]};

controlunit cu (.funct7(f7), .rs2(r2), .rs1(r1), .funct3(f3), .rd(r_d), .opcode(op),
                .imm20(imm20), .imm12(imm12), .imm10(imm10_), .imm8(imm8_), .imm6(imm6_),
                .imm4(imm4_), .imm_1(imm_1_), .imm1(imm1_), .imm(imm_), .zcomp(zero_comp), .alusrc(alusrc_EX),
                .regwrite(regwrite_EX), .regsel(regsel_EX), .op(aluop_EX),
                .gpio_we(hex_we_EX), .pc(pcsrc_EX));

regfile re (.clk(clck), .we(regwrite_WB), .readaddr1(instruction_EX[19:15]),
            .readaddr2(instruction_EX[24:20]), .writeaddr(regdest_WB),
            .writedata(writedata_WB), .readdata1(A_EX), .readdata2(regdata2_EX));

alu myalu (.A(A_EX), .B(B_EX), .op(aluop_EX), .R(R_EX), .zero(z));

endmodule


