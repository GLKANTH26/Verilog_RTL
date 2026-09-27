`include "16by1_hier.v"
module mux16_tb;
	reg a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p;
	reg [3:0]sel;
	wire y;
	mux16 m16(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,sel,y);
	initial begin
		$fsdbDumpvars();
		$monitor("T=%0t sel16=%d y16=%b",$time,sel,y);
		a=0;b=1;c=0;d=1;e=0;f=1;g=0;h=1;i=0;j=1;k=0;l=1;m=0;n=1;o=0;p=1;
		sel=0;
		#10 sel=6; 
		#10 sel=11; 
		#10 sel=15; 
		#10 $finish;
	end
endmodule
