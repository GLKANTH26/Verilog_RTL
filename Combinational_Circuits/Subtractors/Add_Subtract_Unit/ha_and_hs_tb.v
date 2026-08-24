`include "ha_and_hs.v"
module ha_and_hs_tb;
  reg a,b,x;
  wire res,cout;
  ha_and_hs hass(a,b,x,res,cout);
  initial begin
    $fsdbDumpvars();
    $monitor("T=%0t a=%b b=%b x=%b res=%b cout=%b", $time,a,b,x,res,cout);
	{a,b,x} = 3'b000;
	#10;
	{a,b,x} = 3'b001;
	#10;
	{a,b,x} = 3'b010;
	#10;
	{a,b,x} = 3'b011;
	#10;
	{a,b,x} = 3'b100;
	#10;
	{a,b,x} = 3'b101;
	#10;
	{a,b,x} = 3'b110;
	#10;
	{a,b,x} = 3'b111;
	#10;
	$finish;
  end
endmodule

