module decode (

/**** inputs *****************************************************************/

	input logic [31:0] instructaddr,
	
/**** outputs ****************************************************************/

	output logic [6:0] funct7,
	output logic [4:0] rs2,
	output logic [4:0] rs1,
	output logic [2:0] funct3,
	output logic [4:0] rd,
	output logic [6:0] opcode,
	output logic [19:0] imm20,
	output logic [11:0] imm12,
	output logic [9:0] imm10,
	output logic [7:0] imm8,
	output logic [5:0] imm6,
	output logic [3:0] imm4,
	output logic imm_1,
	output logic imm1,
	output logic imm
);
        assign funct7 = instructaddr[31:25];
        assign rs2 = instructaddr [24:20];
        assign rs1 = instructaddr [19:15];
        assign funct3 = instructaddr [14:12];
        assign rd = instructaddr [11:7];
        assign opcode = instructaddr [6:0];
        assign imm20 = instructaddr [31:12];
        assign imm12 = instructaddr [31:20];
        assign imm10 = instructaddr [10:1];
        assign imm6 = instructaddr [10:5];
        assign imm4 = instructaddr [4:1];
        assign imm_1 = instructaddr [11];
        assign imm1 = instructaddr [12];
        assign imm8 = instructaddr [19:12];
        assign imm = instructaddr [20];
        
        
endmodule
// works?
