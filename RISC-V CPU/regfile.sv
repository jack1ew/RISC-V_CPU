/* 32 x 32 register file implementation */

module regfile (

/**** inputs *****************************************************************/

	input logic [0:0 ] clk,		/* clock */
	input logic [0:0 ] we,		/* write enable */
	input logic [4:0 ] readaddr1,		/* read address 1 */
	input logic [4:0 ] readaddr2,		/* read address 2 */
	input logic [4:0 ] writeaddr,		/* write address */
	input logic [31:0] writedata,		/* write data */

/**** outputs ****************************************************************/

	output logic [31:0] readdata1,	/* read data 1 */
	output logic [31:0] readdata2		/* read data 2 */
);

logic [31:0] mem[31:0];

always_ff @(posedge clk) begin
        mem[0] = 32'b0;
	if (we) mem[writeaddr] <= writedata;
	$display("%h", mem[5]);
end

always_comb begin
	
	// $monitor("reg 5: %8h", mem[5]);
	// $monitor("writeaddr: %8h, we: %1h", writeaddr, we);
	
	if (readaddr1 == 5'b0) readdata1 = 32'b0;
	else if (we && readaddr1 == writeaddr) readdata1 = writedata;
	else readdata1 = mem[readaddr1];

	if (readaddr2 == 5'b0) readdata2 = 32'b0;
	else if (we && readaddr2 == writeaddr) readdata2 = writedata;
	else readdata2 = mem[readaddr2];
	
	/*$display("reg1: %h", mem[1]); 
	$display("reg2: %h", mem[2]); 
	$display("reg3: %h", mem[3]);
	$display("reg4: %h", mem[4]);
	$display("reg5: %h", mem[5]); 
	$display("reg6: %h", mem[6]); 
	$display("reg7: %h", mem[7]);
	$display("reg8: %h", mem[8]); 
	$display("reg9: %h", mem[9]); 
	$display("reg10: %h", mem[10]); 
	$display("reg11: %h", mem[11]);
	$display("reg12: %h", mem[12]); 
	$display("reg13: %h", mem[13]); 
	$display("reg14: %h", mem[14]); 
	$display("reg15: %h", mem[15]);
	$display("reg16: %h", mem[16]);
	$display("reg17: %h", mem[17]); 
	$display("reg18: %h", mem[18]); 
	$display("reg19: %h", mem[19]);
	$display("reg20: %h", mem[20]);
	$display("-----------------");*/
end

endmodule
