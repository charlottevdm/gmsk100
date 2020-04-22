//Module: CPU
//Function: CPU is the top design of the processor
//Inputs:
//	clk: main clock
//	arst_n: reset 
// 	enable: Starts the execution
//	addr_ext: Address for reading/writing content to Instruction Memory
//	wen_ext: Write enable for Instruction Memory
// 	ren_ext: Read enable for Instruction Memory
//	wdata_ext: Write word for Instruction Memory
//	addr_ext_2: Address for reading/writing content to Data Memory
//	wen_ext_2: Write enable for Data Memory
// 	ren_ext_2: Read enable for Data Memory
//	wdata_ext_2: Write word for Data Memory
//Outputs:
//	rdata_ext: Read data from Instruction Memory
//	rdata_ext_2: Read data from Data Memory



module cpu(
		input  wire	    clk,
		input  wire         arst_n,
		input  wire         enable,
		input  wire [31:0]  addr_ext,
		input  wire         wen_ext,
		input  wire         ren_ext,
		input  wire [31:0]  wdata_ext,
		input  wire [31:0]  addr_ext_2,
		input  wire         wen_ext_2,
		input  wire         ren_ext_2,
		input  wire [31:0]  wdata_ext_2,
		
		output wire [31:0]  rdata_ext,
		output wire [31:0]  rdata_ext_2

   );


wire              zero_flag;
wire [      31:0] branch_pc,updated_pc,current_pc,jump_pc,
                  instruction;
wire [       1:0] alu_op;
wire [       3:0] alu_control;
wire              reg_dst,branch,mem_read,mem_2_reg,
                  mem_write,alu_src, reg_write, jump;
wire [       4:0] regfile_waddr;
wire [      31:0] regfile_wdata, dram_data,alu_out,
                  regfile_data_1,regfile_data_2,
                  alu_operand_2;

wire [      31:0] instruction_ID,instruction_EX;
wire [      31:0] updated_pc_IF,updated_pc_ID,updated_pc_EX,branch_pc_EX,branch_pc_MEM,jump_pc_EX,jump_pc_MEM;
wire 		  reg_write_ID,reg_write_EX,reg_write_MEM,reg_write_WB;
wire              alu_src_ID,alu_src_EX;
wire [       1:0] alu_op_ID,alu_op_EX;
wire              reg_dst_ID,reg_dst_EX;
wire              mem_2_reg_ID,mem_2_reg_EX,mem_2_reg_MEM,mem_2_reg_WB;
wire              mem_read_ID,mem_read_EX,mem_read_MEM;
wire              mem_write_ID,mem_write_EX,mem_write_MEM;
wire              branch_ID,branch_EX,branch_MEM;
wire [      31:0] read_data_1_ID,read_data_1_EX;
wire [      31:0] read_data_2_ID,read_data_2_EX,read_data_2_MEM;
wire		  zero_flag_EX,zero_flag_MEM;
wire [      31:0] alu_out_EX,alu_out_MEM,alu_out_WB;
wire [       4:0] write_reg_EX,write_reg_MEM,write_reg_WB;
wire [      31:0] read_data_MEM,read_data_WB;
wire		  jump_ID,jump_EX,jump_MEM;

wire signed [31:0] immediate_extended;
wire signed [31:0] immediate_extended_ID, immediate_extended_EX;

///////

assign immediate_extended = $signed(instruction[15:0]);
assign immediate_extended_ID = $signed(instruction_ID[15:0]);

/////////// IF /////////////


pc #(
   .DATA_W(32)
) program_counter (
   .clk       (clk       ),
   .arst_n    (arst_n    ),
   .branch_pc (branch_pc_MEM ), // mem
   .jump_pc   (jump_pc_MEM   ), // mem TODO
   .zero_flag (zero_flag_MEM ), // mem
   .branch    (branch_MEM    ), // mem
   .jump      (jump_MEM      ), // mem TODO
   .current_pc(current_pc),
   .enable    (enable    ),
   .updated_pc(updated_pc_IF)  // if
);

sram #(
   .ADDR_W(9 ),
   .DATA_W(32)
) instruction_memory(
   .clk      (clk           ),
   .addr     (current_pc    ),
   .wen      (1'b0          ),
   .ren      (1'b1          ),
   .wdata    (32'b0         ),
   .rdata    (instruction   ),   
   .addr_ext (addr_ext      ),
   .wen_ext  (wen_ext       ), 
   .ren_ext  (ren_ext       ),
   .wdata_ext(wdata_ext     ),
   .rdata_ext(rdata_ext     )
);

/////////// IF/ID /////////////

reg_arstn_en #(
   .DATA_W(32)
)instruction_IF_ID(
      .clk   (clk       ),
      .arst_n(arst_n    ),
      .din   (instruction ),
      .en    (enable    ),
      .dout  (instruction_ID)
);

reg_arstn_en #(
   .DATA_W(32)
)updated_pc_IF_ID(
      .clk   (clk       ),
      .arst_n(arst_n    ),
      .din   (updated_pc_IF ),
      .en    (enable    ),
      .dout  (updated_pc_ID)
);

/////////// ID /////////////

control_unit control_unit(
   .opcode   (instruction[31:26]),
   .reg_dst  (reg_dst           ), // ID
   .branch   (branch            ), // ID
   .mem_read (mem_read          ), // ID
   .mem_2_reg(mem_2_reg         ), // ID
   .alu_op   (alu_op            ), // ID
   .mem_write(mem_write         ), // ID
   .alu_src  (alu_src           ), // ID
   .reg_write(reg_write         ), // ID
   .jump     (jump              ) // ID
);

mux_2 #(
   .DATA_W(5)
) regfile_dest_mux (
   .input_a (instruction[15:11]), // EX
   .input_b (instruction[20:16]), // EX
   .select_a(reg_dst          ), // EX
   .mux_out (regfile_waddr     ) // EX
);

register_file #(
   .DATA_W(32)
) register_file(
   .clk      (clk               ),
   .arst_n   (arst_n            ),
   .reg_write(reg_write         ), // WB?
   .raddr_1  (instruction[25:21]), // ID?
   .raddr_2  (instruction[20:16]), // ID?
   .waddr    (regfile_waddr     ), // write_reg_WB
   .wdata    (regfile_wdata     ),
   .rdata_1  (regfile_data_1    ), // ID?
   .rdata_2  (regfile_data_2    )  // ID?
);

/////////// ID/EX /////////////

reg_arstn_en #(
	.DATA_W(32)
)instruction_ID_EX(
      	.clk   (clk     ),
     	.arst_n(arst_n  ),
     	.din   (instruction_ID),
     	.en    (enable  ),
    	.dout  (instruction_EX)
);

reg_arstn_en #(
	.DATA_W(32)
)updated_pc_ID_EX(
      	.clk   (clk   ),
     	.arst_n(arst_n),
     	.din   (updated_pc_ID ),
     	.en    (enable),
    	.dout  (updated_pc_EX )
);

reg_arstn_en #(
	.DATA_W(1)
)reg_write_ID_EX(
      	.clk   (clk        ),
     	.arst_n(arst_n     ),
     	.din   (reg_write_ID),
     	.en    (enable     ),
    	.dout  (reg_write_EX)
);

reg_arstn_en #(
	.DATA_W(1)
)alu_src_ID_EX(
      	.clk   (clk        ),
     	.arst_n(arst_n     ),
     	.din   (alu_src_ID),
     	.en    (enable     ),
    	.dout  (alu_src_EX)
);

reg_arstn_en #(
	.DATA_W(2) // 2 bits because there is a first and a second operand
)alu_op_ID_EX(
      	.clk   (clk        ),
     	.arst_n(arst_n     ),
     	.din   (alu_op_ID),
     	.en    (enable     ),
    	.dout  (alu_op_EX)
);

reg_arstn_en #(
	.DATA_W(1)
)reg_dst_ID_EX(
      	.clk   (clk        ),
     	.arst_n(arst_n     ),
     	.din   (reg_dst_ID),
     	.en    (enable     ),
    	.dout  (reg_dst_EX)
);

reg_arstn_en #(
	.DATA_W(1)
)mem_2_reg_ID_EX(
      	.clk   (clk       ),
     	.arst_n(arst_n    ),
     	.din   (mem_2_reg_ID),
     	.en    (enable    ),
    	.dout  (mem_2_reg_EX)
);

reg_arstn_en #(
	.DATA_W(1)
)mem_read_ID_EX(
      	.clk   (clk       ),
     	.arst_n(arst_n    ),
     	.din   (mem_read_ID),
     	.en    (enable    ),
    	.dout  (mem_read_EX)
);

reg_arstn_en #(
	.DATA_W(1)
)mem_write_ID_EX(
      	.clk   (clk        ),
     	.arst_n(arst_n     ),
     	.din   (mem_write_ID),
     	.en    (enable     ),
    	.dout  (mem_write_EX)
);

reg_arstn_en #(
	.DATA_W(1)
)branch_ID_EX(
      	.clk   (clk      ),
     	.arst_n(arst_n   ),
     	.din   (branch_ID),
     	.en    (enable   ),
    	.dout  (branch_EX)
);

reg_arstn_en #(
	.DATA_W(32)
)read_data_1_ID_EX(
      	.clk   (clk      ),
     	.arst_n(arst_n   ),
     	.din   (read_data_1_ID),
     	.en    (enable   ),
    	.dout  (read_data_1_EX)
);

reg_arstn_en #(
	.DATA_W(32)
)read_data_2_ID_EX(
      	.clk   (clk      ),
     	.arst_n(arst_n   ),
     	.din   (read_data_2_ID),
     	.en    (enable   ),
    	.dout  (read_data_2_EX)
);


/////////// EX /////////////

alu_control alu_ctrl(
   .function_field (instruction[5:0]), // EX?
   .alu_op         (alu_op          ), // EX?
   .alu_control    (alu_control     )
);

mux_2 #(
   .DATA_W(32)
) alu_operand_mux (
   .input_a (immediate_extended), // EX
   .input_b (regfile_data_2    ), // EX
   .select_a(alu_src           ), // EX
   .mux_out (alu_operand_2     )
);

alu#(
   .DATA_W(32)
) alu(
   .alu_in_0 (regfile_data_1), // regfile_data_1_EX
   .alu_in_1 (alu_operand_2 ),
   .alu_ctrl (alu_control   ),
   .alu_out  (alu_out       ), // alures_EX
   .shft_amnt(instruction[10:6]), // ID
   .zero_flag(zero_flag     ), // EX
   .overflow (              )
);

/////////// EX/MEM /////////////

reg_arstn_en #(
   .DATA_W(32)
)branch_pc_EX_MEM(
      .clk   (clk       ),
      .arst_n(arst_n    ),
      .din   (branch_pc_EX),
      .en    (enable    ),
      .dout  (branch_pc_MEM)
);

reg_arstn_en #(
   .DATA_W(1)
)zero_flag_EX_MEM(
      .clk   (clk       ),
      .arst_n(arst_n    ),
      .din   (zero_flag_EX),
      .en    (enable    ),
      .dout  (zero_flag_MEM)
);

reg_arstn_en #(
   .DATA_W(32)
)alu_out_EX_MEM(
      .clk   (clk       ),
      .arst_n(arst_n    ),
      .din   (alu_out_EX),
      .en    (enable    ),
      .dout  (alu_out_MEM)
);

reg_arstn_en #(
   .DATA_W(32)
)read_data_2_EX_MEM(
      .clk   (clk       ),
      .arst_n(arst_n    ),
      .din   (read_data_2_EX),
      .en    (enable    ),
      .dout  (read_data_2_MEM)
);

reg_arstn_en #(
	.DATA_W(1)
)reg_write_EX_MEM(
      	.clk   (clk        ),
     	.arst_n(arst_n     ),
     	.din   (reg_write_EX),
     	.en    (enable     ),
    	.dout  (reg_write_MEM)
);

reg_arstn_en #(
	.DATA_W(1)
)mem_2_reg_EX_MEM(
      	.clk   (clk       ),
     	.arst_n(arst_n    ),
     	.din   (mem_2_reg_EX),
     	.en    (enable    ),
    	.dout  (mem_2_reg_MEM)
);

reg_arstn_en #(
	.DATA_W(1)
)mem_read_EX_MEM(
      	.clk   (clk       ),
     	.arst_n(arst_n    ),
     	.din   (mem_read_EX),
     	.en    (enable    ),
    	.dout  (mem_read_MEM)
);

reg_arstn_en #(
	.DATA_W(1)
)mem_write_EX_MEM(
      	.clk   (clk        ),
     	.arst_n(arst_n     ),
     	.din   (mem_write_EX),
     	.en    (enable     ),
    	.dout  (mem_write_MEM)
);

reg_arstn_en #(
	.DATA_W(1)
)branch_EX_MEM(
      	.clk   (clk      ),
     	.arst_n(arst_n   ),
     	.din   (branch_EX),
     	.en    (enable   ),
    	.dout  (branch_MEM)
);

reg_arstn_en #(
	.DATA_W(5)
)write_reg_EX_MEM(
      	.clk   (clk        ),
     	.arst_n(arst_n     ),
     	.din   (write_reg_EX),
     	.en    (enable     ),
    	.dout  (write_reg_MEM)
);

/////////// MEM /////////////

sram #(
   .ADDR_W(10),
   .DATA_W(32)
) data_memory(
   .clk      (clk           ),
   .addr     (alu_out       ),
   .wen      (mem_write     ),
   .ren      (mem_read      ),
   .wdata    (regfile_data_2),
   .rdata    (dram_data     ),   
   .addr_ext (addr_ext_2    ),
   .wen_ext  (wen_ext_2     ),
   .ren_ext  (ren_ext_2     ),
   .wdata_ext(wdata_ext_2   ),
   .rdata_ext(rdata_ext_2   )
);

/////////// MEM/WB /////////////

reg_arstn_en #(
   .DATA_W(1)
)reg_write_MEM_WB(
      .clk   (clk       ),
      .arst_n(arst_n    ),
      .din   (reg_write_MEM),
      .en    (enable    ),
      .dout  (reg_write_WB)
);

reg_arstn_en #(
   .DATA_W(5)
)write_reg_MEM_WB(
      .clk   (clk       ),
      .arst_n(arst_n    ),
      .din   (write_reg_MEM),
      .en    (enable    ),
      .dout  (write_reg_WB)
);

reg_arstn_en #(
   .DATA_W(1)
)mem_2_reg_MEM_WB(
      .clk   (clk       ),
      .arst_n(arst_n    ),
      .din   (mem_2_reg_MEM),
      .en    (enable    ),
      .dout  (mem_2_reg_WB)
);

reg_arstn_en #(
   .DATA_W(32)
)alu_out_MEM_WB(
      .clk   (clk       ),
      .arst_n(arst_n    ),
      .din   (alu_out_MEM),
      .en    (enable    ),
      .dout  (alu_out_WB)
);

reg_arstn_en #(
   .DATA_W(32)
)read_data_MEM_WB(
      .clk   (clk       ),
      .arst_n(arst_n    ),
      .din   (read_data_MEM),
      .en    (enable    ),
      .dout  (read_data_WB)
);

/////////// WB /////////////

mux_2 #(
   .DATA_W(32)
) regfile_data_mux (
   .input_a  (dram_data    ),
   .input_b  (alu_out      ),
   .select_a (mem_2_reg     ),
   .mux_out  (regfile_wdata)
);

branch_unit#(
   .DATA_W(32)
)branch_unit(
   .updated_pc   (updated_pc        ),
   .instruction  (instruction       ),
   .branch_offset(immediate_extended),
   .branch_pc    (branch_pc         ),
   .jump_pc      (jump_pc         )
);


endmodule


