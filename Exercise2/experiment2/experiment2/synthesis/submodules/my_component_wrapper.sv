// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

module my_component_wrapper (
	input logic clock,
	input logic resetn,

	input  logic [1:0] 	address,
	input  logic 		chipselect,
	input  logic 		read,
	input  logic 		write,
	output logic [31:0]	readdata,
	input  logic [31:0]	writedata,
	output logic my_component_irq
);
//from NIOS
logic [8:0] 	memaddr, memaddr_irq; 
logic [15:0] 	memdata, memdata_irq;
//from RAM
logic [15:0] 	ram_data, ram_data_irq;
logic 			wren_a, wren_b;
logic 			start_search;
logic [31:0] 	search_result;
logic				my_component_irq_buf, my_component_irq_done, clear_irq;
logic	[25:0]   counter_value;
// for getting the configuration from NIOS
always_ff @ (posedge clock or negedge resetn) begin
	if (!resetn) begin
		memaddr <= 16'd0;
		memdata <= 16'd0;
		start_search <= 1'd0;
		wren_a <= 1'b0;
		wren_b <= 1'b0;
	end else begin
		memdata <= 16'b0;
		if (chipselect & write) begin
			case (address)
			'd1: begin
				if(writedata[25] == 1)begin
					wren_a <= write;
					memaddr <= writedata[24:16];
					memdata <= writedata[15:0];
				end
				else begin
					wren_a <= 1'b0;
					memaddr <= writedata[24:16];
				end
			end
			'd3: begin
				start_search <= writedata[31];
				clear_irq	<=  writedata[0];
			end
			endcase
		end
		if(wren_a == 1'b1) begin
			wren_a <= 1'b0;
		end
		if(~clear_irq) begin
			clear_irq <= 1'b1;
		end
		if(start_search) begin
			start_search <= 1'b0;
		end
	end
end

always_ff @ (posedge clock or negedge resetn) begin
	if (!resetn) begin
		my_component_irq_buf <= 1'b0;
	end else begin
		my_component_irq_buf <= my_component_irq_done;
		if (my_component_irq_done & ~my_component_irq_buf) begin
			my_component_irq <= 1'b1;
			search_result <= 32'hf0f0f0f0;
		end
		if (clear_irq) my_component_irq <= 1'b0;
	end
end

always_ff @ (posedge clock or negedge resetn) begin
	if (!resetn) begin
		counter_value <= 'd49999999;
	end else begin
		if(start_search) begin
			counter_value <= 'd49999999;
		end else if (counter_value > 'd0) counter_value <= counter_value - 'd1;
		if (counter_value == 'd0) my_component_irq_done <= 1'b1;
		if (start_search) begin
			my_component_irq_done <= 1'b0;
		end
	end
end

// for sending information to NIOS
always_ff @ (posedge clock or negedge resetn) begin
	if (!resetn) begin
		readdata <= 'd0;
	end else begin
		if (chipselect & read) begin
			case (address)
			'd0: readdata <= {16'd0, ram_data};
			'd2: readdata <= search_result;
			endcase
		end
	end
end

my_component my_component_inst (
	.clock(clock),
	.address_a(memaddr),
	.address_b(memaddr_irq),
	.data_a(memdata),
	.data_b(memdata_irq),
	.wren_a(wren_a),
	.wren_b(wren_b),
	.q_a(ram_data),
	.q_b(ram_data_irq)
);
/*
input	[8:0]  address_a;
input	[8:0]  address_b;
input	  clock;
input	[15:0]  data_a;
input	[15:0]  data_b;
input	  wren_a;
input	  wren_b;
output	[15:0]  q_a;
output	[15:0]  q_b;
*/
endmodule
