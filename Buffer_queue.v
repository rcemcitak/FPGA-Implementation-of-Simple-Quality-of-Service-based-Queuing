`timescale 1ns / 1ps
module Buffer_queue(
	input clk,           // 50 MHz
	input  start,
   input one,
	input zero,
	output reg [3:0] outputdata,
	output o_hsync,      // horizontal sync
	output o_vsync,	     // vertical sync
	output [7:0] o_red,
	output [7:0] o_blue,
	output [7:0] o_green,
	output Vga_clock
	
);


	reg [9:0] hcount = 0;  // horizontal counter
	reg [9:0] new_hcount = 0;  // horizontal counter
	reg [9:0] vcount = 0;  // vertical counter
	reg [7:0] red = 0;
	reg [7:0] blue = 0;
	reg [7:0] green = 0;
 

reg [9:0] hcoun = 0;
reg [9:0] vcoun = 0;
	integer counter=0;
	
	reg reset = 0;  // for PLL
	
	reg clk25MHz=0; 
	reg [17:0] Buffer1=0, Buffer2=0, Buffer3=0, Buffer4=0;
reg [3:0] temp;
reg control =0, write=0, startready=0,zeroready=0,oneready=0;
integer i =0,counter1=0,counter2=0,counter3=0,counter4=0,clockcounter=0;
integer wrote_data1 =0,wrote_data2 =0,wrote_data3 =0,wrote_data4 =0,loss_data1=0,loss_data2=0,loss_data3=0,loss_data4=0;
integer read_data1=0,read_data2=0,read_data3=0,read_data4=0;

initial begin

Buffer1[0] =1;
Buffer1[1] =1;
Buffer1[2] =0;
Buffer1[3] =1;
Buffer1[4] =0;
Buffer1[5] =0;
Buffer1[6] =1;
Buffer1[7] =1;
Buffer1[8] =1;
Buffer1[9] =1;
Buffer1[10] =0;
Buffer1[11] =1;
Buffer1[12] =1;
Buffer1[13] =1;
Buffer1[14] =0;
Buffer1[15] =0;
Buffer1[16] =0;
Buffer1[17] =0;

Buffer2[0] =1;
Buffer2[1] =1;
Buffer2[2] =0;
Buffer2[3] =1;
Buffer2[4] =0;
Buffer2[5] =0;
Buffer2[6] =1;
Buffer2[7] =1;
Buffer2[8] =1;
Buffer2[9] =1;
Buffer2[10] =0;
Buffer2[11] =1;
Buffer2[12] =1;
Buffer2[13] =1;
Buffer2[14] =0;
Buffer2[15] =1;
Buffer2[16] =1;
Buffer2[17] =0;

Buffer3[0] =1;
Buffer3[1] =1;
Buffer3[2] =0;
Buffer3[3] =1;
Buffer3[4] =0;
Buffer3[5] =0;
Buffer3[6] =1;
Buffer3[7] =1;
Buffer3[8] =1;
Buffer3[9] =1;
Buffer3[10] =0;
Buffer3[11] =1;
Buffer3[12] =1;
Buffer3[13] =1;
Buffer3[14] =0;
Buffer3[15] =0;
Buffer3[16] =0;
Buffer3[17] =0;

Buffer4[0] =1;
Buffer4[1] =1;
Buffer4[2] =0;
Buffer4[3] =1;
Buffer4[4] =0;
Buffer4[5] =0;
Buffer4[6] =1;
Buffer4[7] =1;
Buffer4[8] =1;
Buffer4[9] =1;
Buffer4[10] =0;
Buffer4[11] =1;
Buffer4[12] =1;
Buffer4[13] =1;
Buffer4[14] =0;
Buffer4[15] =1;
Buffer4[16] =1;
Buffer4[17] =0;


end

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	always @(posedge clk)begin
	clockcounter=clockcounter+1;

	if(start==1)
		startready=1;
	if(~(start) && startready) begin // starts to write
		control=1;
		startready=0;
	end		
	
	if(one == 1)
		oneready =1;
	if(~(one) && control && oneready) begin
		temp[i] = 1;
		i = i+1;
		oneready=0; 
	end	
	
	if(zero==1)
		zeroready=1;
	if( ~(zero) && control && zeroready) begin
		temp[i] = 0;
		i = i+1;
		zeroready=0;
	end

	if(i ==4)begin
		i=0;
		control =0;
		write =1;
	end

	if(write==1)begin
		if(temp[0] == 0 && temp[1] ==0)begin
			if(Buffer1[15] ==1)
				loss_data1 = loss_data1+1;				
			Buffer1 = Buffer1<<3;
			Buffer1[0]=1;
			Buffer1[1]=temp[2];
			Buffer1[2]=temp[3];
			temp=0;
			write=0;
			wrote_data1 = wrote_data1+1;

		end
		if(temp[0] == 0 && temp[1] ==1)begin
			if(Buffer2[15] ==1)
				loss_data2 = loss_data2+1;	
			Buffer2 = Buffer2<<3;
			Buffer2[0]=1;
			Buffer2[1]=temp[2];
			Buffer2[2]=temp[3];
			temp=0;
			write=0;
			wrote_data2 = wrote_data2+1;
		end
		if(temp[0] == 1 && temp[1] ==0)begin
			if(Buffer3[15] ==1)
				loss_data3 = loss_data3+1;	
			Buffer3 = Buffer3<<3;
			Buffer3[0]=1;
			Buffer3[1]=temp[2];
			Buffer3[2]=temp[3];
			temp=0;
			write=0;
			wrote_data3 = wrote_data3+1;
			
		end
		if(temp[0] == 1 && temp[1] ==1)begin
			if(Buffer4[15] ==1)
				loss_data4 = loss_data4+1;	
			Buffer4 = Buffer4<<3;
			Buffer4[0]=1;
			Buffer4[1]=temp[2];
			Buffer4[2]=temp[3];
			temp=0;
			write=0;			
			wrote_data4 = wrote_data4+1;
		end
	end
	
		
	if(Buffer1[15] == 1)begin
	counter1 = 6;
	end
	else if(Buffer1[12] == 1)begin
	counter1= 5;
	end
		else if(Buffer1[9] == 1)begin
	counter1= 4;
	end
		else if(Buffer1[6] == 1)begin
	counter1= 3;
	end
		else if(Buffer1[3] == 1)begin
	counter1= 2;
	end
		else if(Buffer1[0] == 1)begin
	counter1= 1;
	end
	else 
	counter1 = 0;
	
		if(Buffer2[15] == 1)begin
	counter2 = 6;
	end
	else if(Buffer2[12] == 1)begin
	counter2= 5;
	end
		else if(Buffer2[9] == 1)begin
	counter2= 4;
	end
		else if(Buffer2[6] == 1)begin
	counter2= 3;
	end
		else if(Buffer2[3] == 1)begin
	counter2= 2;
	end
		else if(Buffer2[0] == 1)begin
	counter2= 1;
	end
	else 
	counter2 = 0;
		if(Buffer3[15] == 1)begin
	counter3 = 6;
	end
	else if(Buffer3[12] == 1)begin
	counter3= 5;
	end
		else if(Buffer3[9] == 1)begin
	counter3= 4;
	end
		else if(Buffer3[6] == 1)begin
	counter3= 3;
	end
		else if(Buffer3[3] == 1)begin
	counter3= 2;
	end
		else if(Buffer3[0] == 1)begin
	counter3= 1;
	end
	else 
	counter3 = 0;
		if(Buffer4[15] == 1)begin
	counter4 = 6;
	end
	else if(Buffer4[12] == 1)begin
	counter4= 5;
	end
		else if(Buffer4[9] == 1)begin
	counter4= 4;
	end
		else if(Buffer4[6] == 1)begin
	counter4= 3;
	end
		else if(Buffer4[3] == 1)begin
	counter4= 2;
	end
		else if(Buffer4[0] == 1)begin
	counter4= 1;
	end
	else 
	counter4 = 0;

	
	if(clockcounter==150000000)begin // read operation

		clockcounter = 0;
		if(Buffer4[15] == 1)begin
			  outputdata[0] = 1;
			  outputdata[1] = 1;
			  outputdata[2] = Buffer4[16];
			  outputdata[3] = Buffer4[17];
			  read_data4 = read_data4+1;
			  Buffer4[15] = 0;
			  Buffer4[16] = 0;
			  Buffer4[17] = 0;
			  
		end
		else if(Buffer3[15] == 1)begin
			  outputdata[0] = 1;
			  outputdata[1] = 0;
			  outputdata[2] = Buffer3[16];
			  outputdata[3] = Buffer3[17];
			  read_data3 = read_data3+1;
			  Buffer3[15] = 0;
			  Buffer3[16] = 0;
			  Buffer3[17] = 0;
		 end
		 else if(Buffer2[15] == 1)begin
			  outputdata[0] = 0;
			  outputdata[1] = 1;
			  outputdata[2] = Buffer2[16];
			  outputdata[3] = Buffer2[17];
			  read_data2 = read_data2+1;
			  Buffer2[15] = 0;
			  Buffer2[16] = 0;
			  Buffer2[17] = 0;
			  
		 end
		 else if(Buffer1[15] == 1)begin
			  outputdata[0] = 0;
			  outputdata[1] = 0;
			  outputdata[2] = Buffer1[16];
			  outputdata[3] = Buffer1[17];
			  read_data1 = read_data1+1;
			  Buffer1[15] = 0;
			  Buffer1[16] = 0;
			  Buffer1[17] = 0;
		 end
		 else if(counter1 >0)begin
			  outputdata[0] = 0;
			  outputdata[1] = 0;
			  outputdata[2] = Buffer1[counter1*3-2];
			  outputdata[3] = Buffer1[counter1*3-1];
			 
			  Buffer1[counter1*3-3]=0;
			  Buffer1[counter1*3-2]=0;
			  Buffer1[counter1*3-1]=0;	
			  read_data1 = read_data1+1;		  
		 end
		 else if(counter2 >0)begin
			  outputdata[0] = 0;
			  outputdata[1] = 1;
			  outputdata[2] = Buffer2[counter2*3-2];
			  outputdata[3] = Buffer2[counter2*3-1];
			  
			  Buffer2[counter2*3-3]=0;
			  Buffer2[counter2*3-2]=0;
			  Buffer2[counter2*3-1]=0;		
			  read_data2 = read_data2+1;
		 end
		 else if(counter3 >0)begin
			  outputdata[0] = 1;
			  outputdata[1] = 0;
			  outputdata[2] = Buffer3[counter3*3-2];
			  outputdata[3] = Buffer3[counter3*3-1];
			  
			  Buffer3[counter3*3-3]=0;
			  Buffer3[counter3*3-2]=0;
			  Buffer3[counter3*3-1]=0;	
		     read_data3 = read_data3+1; 
		 end
		 else if(counter4 >0)begin
			  outputdata[0] = 1;
			  outputdata[1] = 1;
			  outputdata[2] = Buffer4[counter4*3-2];
			  outputdata[3] = Buffer4[counter4*3-1];
			  
			  Buffer4[counter4*3-3]=0;
			  Buffer4[counter4*3-2]=0;
			  Buffer4[counter4*3-1]=0;		
			  read_data4 = read_data4+1;
		 end
	end	
	end
	always @ (posedge clk)
 begin
 counter = counter+1;
 if (counter ==1)
 begin
 clk25MHz=~clk25MHz;
 counter=0;  
 end
end

assign Vga_clock = clk25MHz;
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// counter and sync generation */
	always @(posedge clk25MHz)  // horizontal counter
		begin 
			if (new_hcount < 799)
				new_hcount <= new_hcount + 1;  // horizontal counter (including off-screen horizontal 160 pixels) total of 800 pixels 
			else
				new_hcount <= 0;              
		end  // always 
	
	always @ (posedge clk25MHz)  // vertical counter
		begin 
			if (new_hcount == 799)  // only counts up 1 count after horizontal finishes 800 counts
				begin
					if (vcount < 525)  // vertical counter (including off-screen vertical 45 pixels) total of 525 pixels
						vcount <= vcount + 1;
					else
						vcount <= 0;              
				end  // if (counter_x...
		end  // always
	// end counter and sync generation  

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// hsync and vsync output assignments
	assign o_hsync = ~(new_hcount >= 0 && new_hcount < 2) ? 1:0;  // hsync high for 96 counts                                                 
	assign o_vsync = ~(vcount >= 0 && vcount < 2) ? 1:0;   // vsync high for 2 counts
	// end hsync and vsync output assignments

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// pattern generate
		always @ (posedge clk)
		begin
		hcount = new_hcount-120;
		if (((hcount>2)&&(hcount  <40) || (hcount > 261 && hcount<315) || (hcount>540 && hcount <640)) && (vcount>0 && vcount<480))
		begin
		green <= 8'hff;
      blue <= 8'hff; 
      red <= 8'hff;
		end
		else if((hcount>39&& hcount<265 &&vcount < 400 && vcount>60))begin
		
		 if ((hcount == 40 || hcount == 80 || hcount == 100 ||hcount == 140 ||hcount == 160 ||hcount == 200  ||hcount == 220 ||hcount == 260 )&& vcount < 351 && vcount > 109 ) 
    begin
      green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
    end
    else if ((vcount == 110 || vcount == 150 ||   vcount == 190 ||   vcount == 230 ||   vcount == 270 ||  vcount == 310 ||   vcount == 350)&&((hcount > 40 && hcount < 80)||(hcount > 100 && hcount < 140)||(hcount > 160 && hcount < 200)||(hcount > 220 && hcount < 260))) 
    begin
      green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
    end
	 else if (hcount < 80 && hcount > 40 && vcount < 350 && vcount > 310 && Buffer1[0] == 1)begin
		if(Buffer1[1] == 0 && Buffer1[2] == 0)begin
			if(((vcount == 330 || vcount== 326) && (hcount == 59 || hcount == 60))||((vcount==327 || vcount==328 || vcount == 329) && (hcount==58 || hcount == 61)))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'hff;
			end
		end
		else if(Buffer1[1] == 0 && Buffer1[2] == 1)begin
			if(((vcount < 331 && vcount> 325) && hcount == 59) ||(vcount==329  && (hcount==58 || hcount == 59 || hcount == 60)) || (hcount == 58 && vcount == 327))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'hff;
			end
		end
		else if(Buffer1[1] == 1 && Buffer1[2] == 0)begin
			if((vcount == 330 && hcount >57 && hcount <61) || (hcount == 59 && (vcount == 329 || vcount == 326)) || 	(hcount == 60 && (vcount == 326 || vcount == 328))|| (vcount == 327 && (hcount == 61 || hcount == 58)))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'hff;
			end
		
		end
		else if(Buffer1[1] == 1 && Buffer1[2] == 1)begin
			if(((vcount == 327 || vcount == 331)&&(hcount==59 || hcount == 60)) ||((vcount == 328 || vcount ==  330) && (hcount == 58 || hcount == 61)) || (vcount == 329 && hcount == 60))begin 
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
		end
			else 
			begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'hff;
			end
		
		end
		
		
	 end
	 else if (hcount < 80 && hcount > 40 && vcount < 310 && vcount > 270 && Buffer1[3] == 1)begin
		vcoun = vcount + 40;
	 	if(Buffer1[4] == 0 && Buffer1[5] == 0)begin
			if(((vcoun == 330 || vcoun== 326) && (hcount == 59 || hcount == 60))||((vcoun==327 || vcoun==328 || vcoun == 329) && (hcount==58 || hcount == 61)))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'hff;
			end
		end
		else if(Buffer1[4] == 0 && Buffer1[5] == 1)begin
			if(((vcoun < 331 && vcoun> 325) && hcount == 59) ||(vcoun==329  && (hcount==58 || hcount == 59 || hcount == 60)) || (hcount == 58 && vcoun == 327))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'hff;
			end
		end
		else if(Buffer1[4] == 1 && Buffer1[5] == 0)begin
			if((vcoun == 330 && hcount >57 && hcount <61) || (hcount == 59 && (vcoun == 329 || vcoun == 326)) || 	(hcount == 60 && (vcoun == 326 || vcoun == 328))|| (vcoun == 327 && (hcount == 61 || hcount == 58)))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'hff;
			end
		
		end
		else if(Buffer1[4] == 1 && Buffer1[5] == 1)begin
			if(((vcoun == 327 || vcoun == 331)&&(hcount==59 || hcount == 60)) ||((vcoun == 328 || vcoun ==  330) && (hcount == 58 || hcount == 61)) || (vcoun == 329 && hcount == 60))begin 
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
		end
			else 
			begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'hff;
			end
		
		end
		vcoun = vcount -40;		
	 end
	 
	 
	 
	 
	 else if (hcount < 80 && hcount > 40 && vcount < 270 && vcount > 230 && Buffer1[6] == 1)begin
		vcoun = vcount + 80;
	 	if(Buffer1[7] == 0 && Buffer1[8] == 0)begin
			if(((vcoun == 330 || vcoun== 326) && (hcount == 59 || hcount == 60))||((vcoun==327 || vcoun==328 || vcoun == 329) && (hcount==58 || hcount == 61)))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'hff;
			end
		end
		else if(Buffer1[7] == 0 && Buffer1[8] == 1)begin
			if(((vcoun < 331 && vcoun> 325) && hcount == 59) ||(vcoun==329  && (hcount==58 || hcount == 59 || hcount == 60)) || (hcount == 58 && vcoun == 327))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'hff;
			end
		end
		else if(Buffer1[7] == 1 && Buffer1[8] == 0)begin
			if((vcoun == 330 && hcount >57 && hcount <61) || (hcount == 59 && (vcoun == 329 || vcoun == 326)) || 	(hcount == 60 && (vcoun == 326 || vcoun == 328))|| (vcoun == 327 && (hcount == 61 || hcount == 58)))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'hff;
			end
		
		end
		else if(Buffer1[7] == 1 && Buffer1[8] == 1)begin
			if(((vcoun == 327 || vcoun== 331)&&(hcount==59 || hcount == 60)) ||((vcoun == 328 || vcoun ==  330) && (hcount == 58 || hcount == 61)) || (vcoun == 329 && hcount == 60))begin 
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'hff;
			end
		
		end
		vcoun = vcount -80;		
	 end
	 else if (hcount < 80 && hcount > 40 && vcount < 230 && vcount > 190 && Buffer1[9] == 1)begin
		vcoun = vcount + 120;
	 	if(Buffer1[10] == 0 && Buffer1[11] == 0)begin
			if(((vcoun == 330 || vcoun== 326) && (hcount == 59 || hcount == 60))||((vcoun==327 || vcoun==328 || vcoun == 329) && (hcount==58 || hcount == 61)))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'hff;
			end
		end
		else if(Buffer1[10] == 0 && Buffer1[11] == 1)begin
			if(((vcoun < 331 && vcoun> 325) && hcount == 59) ||(vcoun==329  && (hcount==58 || hcount == 59 || hcount == 60)) || (hcount == 58 && vcoun == 327))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <=8'h00;
			end
			else 
			begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'hff;
			end
		end
		else if(Buffer1[10] == 1 && Buffer1[11] == 0)begin
			if((vcoun == 330 && hcount >57 && hcount <61) || (hcount == 59 && (vcoun == 329 || vcoun == 326)) || 	(hcount == 60 && (vcoun == 326 || vcoun == 328))|| (vcoun == 327 && (hcount == 61 || hcount == 58)))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'hff;
			end
		
		end
		else if(Buffer1[10] == 1 && Buffer1[11] == 1)begin
			if(((vcoun == 327 || vcoun == 331)&&(hcount==59 || hcount == 60)) ||((vcoun == 328 || vcount ==  330) && (hcount == 58 || hcount == 61)) || (vcoun == 329 && hcount == 60))begin 
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'hff;
			end
		
		end
		vcoun = vcount -120;		
	 end
	 else if (hcount < 80 && hcount > 40 && vcount < 190 && vcount > 150 && Buffer1[12] == 1)begin
		vcoun = vcount + 160;
	 	if(Buffer1[13] == 0 && Buffer1[14] == 0)begin
			if(((vcoun == 330 || vcoun== 326) && (hcount == 59 || hcount == 60))||((vcoun==327 || vcoun==328 || vcoun == 329) && (hcount==58 || hcount == 61)))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'hff;
			end
		end
		else if(Buffer1[13] == 0 && Buffer1[14] == 1)begin
			if(((vcoun < 331 && vcoun> 325) && hcount == 59) ||(vcoun==329  && (hcount==58 || hcount == 59 || hcount == 60)) || (hcount == 58 && vcoun == 327))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'hff;
			end
		end
		else if(Buffer1[13] == 1 && Buffer1[14] == 0)begin
			if((vcoun == 330 && hcount >57 && hcount <61) || (hcount == 59 && (vcoun == 329 || vcoun == 326)) || 	(hcount == 60 && (vcoun == 326 || vcoun == 328))|| (vcoun == 327 && (hcount == 61 || hcount == 58)))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'hff;
			end
		
		end
		else if(Buffer1[13] == 1 && Buffer1[14] == 1)begin
			if(((vcoun == 327 || vcoun == 331)&&(hcount==59 || hcount == 60)) ||((vcoun == 328 || vcoun ==  330) && (hcount == 58 || hcount == 61)) || (vcoun == 329 && hcount == 60))begin 
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'hff;
			end
		
		end
		vcoun = vcount -160;		
	 end
	 else if (hcount < 80 && hcount > 40 && vcount < 150 && vcount > 110 && Buffer1[15] == 1)begin
		vcoun = vcount + 200;
	 	if(Buffer1[16] == 0 && Buffer1[17] == 0)begin
			if(((vcoun == 330 || vcoun== 326) && (hcount == 59 || hcount == 60))||((vcoun==327 || vcoun==328 || vcoun == 329) && (hcount==58 || hcount == 61)))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'hff;
			end
		end
		else if(Buffer1[16] == 0 && Buffer1[17] == 1)begin
			if(((vcoun < 331 && vcoun> 325) && hcount == 59) ||(vcoun==329  && (hcount==58 || hcount == 59 || hcount == 60)) || (hcount == 58 && vcoun == 327))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'hff;
			end
		end
		else if(Buffer1[16] == 1 && Buffer1[17] == 0)begin
			if((vcoun == 330 && hcount >57 && hcount <61) || (hcount == 59 && (vcoun == 329 || vcoun == 326)) || 	(hcount == 60 && (vcoun == 326 || vcoun == 328))|| (vcoun == 327 && (hcount == 61 || hcount == 58)))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'hff;
			end
		
		end
		else if(Buffer1[16] == 1 && Buffer1[17] == 1)begin
			if(((vcoun == 327 || vcoun == 331)&&(hcount==59 || hcount == 60)) ||((vcoun == 328 || vcoun ==  330) && (hcount == 58 || hcount == 61)) || (vcoun == 329 && hcount == 60))begin 
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'hff;
			end
		
		end
		vcoun = vcount -200;		
	 end

    else if (hcount < 140 && hcount > 100 && vcount < 350 && vcount > 310 && Buffer2[0] == 1)begin
	 hcoun = hcount -60;
		if(Buffer2[1] == 0 && Buffer2[2] == 0)begin
			if(((vcount == 330 || vcount== 326) && (hcoun == 59 || hcoun == 60))||((vcount==327 || vcount==328 || vcount == 329) && (hcoun==58 || hcoun == 61)))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'h00;
				blue <= 8'hff; 
				red <= 8'h00;
			end
		end
		else if(Buffer2[1] == 0 && Buffer2[2] == 1)begin
			if(((vcount < 331 && vcount> 325) && hcoun == 59) ||(vcount==329  && (hcoun==58 || hcoun == 59 || hcoun == 60)) || (hcoun == 58 && vcount == 327))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'h00;
				blue <= 8'hff; 
				red <= 8'h00;
			end
		end
		else if(Buffer2[1] == 1 && Buffer2[2] == 0)begin
			if((vcount == 330 && hcoun >57 && hcoun <61) || (hcoun == 59 && (vcount == 329 || vcount == 326)) || 		(hcoun == 60 && (vcount == 326 || vcount == 328))|| (vcount == 327 && (hcoun == 61 || hcoun == 58)))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'h00;
				blue <= 8'hff; 
				red <= 8'h00;
			end
		
		end
		else if(Buffer2[1] == 1 && Buffer2[2] == 1)begin
			if(((vcount == 327 || vcount == 331)&&(hcoun==59 || hcoun == 60)) ||((vcount == 328 || vcount ==  330) && (hcoun == 58 || hcoun == 61)) || (vcount == 329 && hcoun == 60))begin 
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'h00;
				blue <= 8'hff; 
				red <= 8'h00;
			end
		end
	 hcoun = hcount +60;
	 end
 
 
 
    else if (hcount < 140 && hcount > 100 && vcount < 310 && vcount > 270 && Buffer2[3] == 1)begin
	 hcoun = hcount -60;
	 vcoun = vcount +40;
		if(Buffer2[4] == 0 && Buffer2[5] == 0)begin
			if(((vcoun == 330 || vcoun== 326) && (hcoun == 59 || hcoun == 60))||((vcoun==327 || vcoun==328 || vcoun == 329) && (hcoun==58 || hcoun == 61)))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'h00;
				blue <= 8'hff; 
				red <= 8'h00;
			end
		end
		else if(Buffer2[4] == 0 && Buffer2[5] == 1)begin
			if(((vcoun < 331 && vcoun> 325) && hcoun == 59) ||(vcoun==329  && (hcoun==58 || hcoun == 59 || hcoun == 60)) || (hcoun == 58 && vcoun == 327))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'h00;
				blue <= 8'hff; 
				red <= 8'h00;
			end
		end
		else if(Buffer2[4] == 1 && Buffer2[5] == 0)begin
			if((vcoun == 330 && hcoun >57 && hcoun <61) || (hcoun == 59 && (vcoun == 329 || vcoun == 326)) || 	(hcoun == 60 && (vcoun == 326 || vcoun == 328))|| (vcoun == 327 && (hcoun == 61 || hcoun == 58)))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
		end
			else 
			begin
				green <= 8'h00;
				blue <= 8'hff; 
				red <= 8'h00;
			end
		
		end
		else if(Buffer2[4] == 1 && Buffer2[5] == 1)begin
			if(((vcoun == 327 || vcoun == 331)&&(hcoun==59 || hcoun == 60)) ||((vcoun == 328 || vcoun ==  330) && (hcoun == 58 || hcoun == 61)) || (vcoun == 329 && hcoun == 60))begin 
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'h00;
				blue <= 8'hff; 
				red <= 8'h00;
			end
		end
	 hcoun= hcount +60;
	 vcoun = vcount -40;
	 end
	 else if (hcount < 140 && hcount > 100 && vcount < 270 && vcount > 230 && Buffer2[6] == 1)begin
	 hcoun = hcount -60;
	 vcoun = vcount +80;
		if(Buffer2[7] == 0 && Buffer2[8] == 0)begin
			if(((vcoun == 330 || vcoun== 326) && (hcoun == 59 || hcoun == 60))||((vcoun==327 || vcoun==328 || vcoun == 329) && (hcoun==58 || hcoun == 61)))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'h00;
				blue <= 8'hff; 
				red <= 8'h00;
			end
		end
		else if(Buffer2[7] == 0 && Buffer2[8] == 1)begin
			if(((vcoun < 331 && vcoun> 325) && hcoun == 59) ||(vcoun==329  && (hcoun==58 || hcoun == 59 || hcoun == 60)) || (hcoun == 58 && vcoun == 327))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'h00;
				blue <= 8'hff; 
				red <= 8'h00;
			end
		end
		else if(Buffer2[7] == 1 && Buffer2[8] == 0)begin
			if((vcoun == 330 && hcoun >57 && hcoun <61) || (hcoun == 59 && (vcoun == 329 || vcoun == 326)) || 	(hcoun == 60 && (vcoun == 326 || vcoun == 328))|| (vcoun == 327 && (hcoun == 61 || hcoun == 58)))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
		end
			else 
			begin
				green <= 8'h00;
				blue <= 8'hff; 
				red <= 8'h00;
			end
		
		end
		else if(Buffer2[7] == 1 && Buffer2[8] == 1)begin
			if(((vcoun == 327 || vcoun== 331)&&(hcoun==59 || hcoun == 60)) ||((vcoun == 328 || vcoun ==  330) && (hcoun == 58 || hcoun == 61)) || (vcoun == 329 && hcoun == 60))begin 
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
		end
			else 
			begin
				green <= 8'h00;
				blue <= 8'hff; 
				red <= 8'h00;
			end
		end
	 hcoun = hcount +60;
	 vcoun=vcount-80;
	 end
	 else if (hcount < 140 && hcount > 100 && vcount < 230 && vcount > 190 && Buffer2[9] == 1)begin
	 hcoun = hcount -60;
	 vcoun = vcount +120;
		if(Buffer2[10] == 0 && Buffer2[11] == 0)begin
			if(((vcoun == 330 || vcoun== 326) && (hcoun == 59 || hcoun == 60))||((vcoun==327 || vcoun==328 || vcoun == 329) && (hcoun==58 || hcoun == 61)))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'h00;
				blue <= 8'hff; 
				red <= 8'h00;
			end
		end
		else if(Buffer2[10] == 0 && Buffer2[11] == 1)begin
			if(((vcoun < 331 && vcoun> 325) && hcoun == 59) ||(vcoun==329  && (hcoun==58 || hcoun == 59 || hcoun == 60)) || (hcoun == 58 && vcoun == 327))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'h00;
				blue <= 8'hff; 
				red <= 8'h00;
			end
		end
		else if(Buffer2[10] == 1 && Buffer2[11] == 0)begin
		if((vcoun == 330 && hcoun >57 && hcoun <61) || (hcoun == 59 && (vcoun == 329 || vcoun == 326)) || 	(hcoun == 60 && (vcoun == 326 || vcoun == 328))|| (vcoun == 327 && (hcoun == 61 || hcoun == 58)))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'h00;
				blue <= 8'hff; 
				red <= 8'h00;
			end
		
		end
		else if(Buffer2[10] == 1 && Buffer2[11] == 1)begin
			if(((vcoun == 327 || vcoun == 331)&&(hcoun==59 || hcoun == 60)) ||((vcoun == 328 || vcoun ==  330) && (hcoun == 58 || hcoun == 61)) || (vcoun == 329 && hcoun == 60))begin 
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'h00;
				blue <= 8'hff; 
				red <= 8'h00;
			end
		end
	 hcoun = hcount +60;
	 vcoun = vcount -120;
	 end
	 else if (hcount < 140 && hcount > 100 && vcount < 190 && vcount > 150 && Buffer2[12] == 1)begin
	 hcoun = hcount -60;
	 vcoun=vcount+160;
		if(Buffer2[13] == 0 && Buffer2[14] == 0)begin
			if(((vcoun == 330 || vcoun== 326) && (hcoun == 59 || hcoun == 60))||((vcoun==327 || vcoun==328 || vcoun == 329) && (hcoun==58 || hcoun == 61)))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'h00;
				blue <= 8'hff; 
				red <= 8'h00;
			end
		end
		else if(Buffer2[13] == 0 && Buffer2[14] == 1)begin
			if(((vcoun < 331 && vcoun> 325) && hcoun == 59) ||(vcoun==329  && (hcoun==58 || hcoun == 59 || hcoun == 60)) || (hcoun == 58 && vcoun == 327))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'h00;
				blue <= 8'hff; 
				red <= 8'h00;
			end
		end
		else if(Buffer2[13] == 1 && Buffer2[14] == 0)begin
			if((vcoun == 330 && hcoun >57 && hcoun <61) || (hcoun == 59 && (vcoun == 329 || vcoun == 326)) || (hcoun == 60 && (vcoun == 326 || vcoun == 328))|| (vcoun == 327 && (hcoun == 61 || hcoun == 58)))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'h00;
				blue <= 8'hff; 
				red <= 8'h00;
			end
		
		end
		else if(Buffer2[13] == 1 && Buffer2[14] == 1)begin
			if(((vcoun == 327 || vcoun == 331)&&(hcoun==59 || hcoun == 60)) ||((vcoun == 328 || vcoun ==  330) && (hcoun == 58 || hcoun == 61)) || (vcoun == 329 && hcoun == 60))begin 
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'h00;
				blue <= 8'hff; 
				red <= 8'h00;
			end
		end
	 hcoun = hcount +60;
	 vcoun =vcount - 160;
	 end
	 else if (hcount < 140 && hcount > 100 && vcount < 150 && vcount > 110 && Buffer2[15] == 1)begin
	 hcoun = hcount -60;
	 vcoun = vcount +200;
		if(Buffer2[16] == 0 && Buffer2[17] == 0)begin
			if(((vcoun == 330 || vcoun== 326) && (hcoun == 59 || hcoun == 60))||((vcoun==327 || vcoun==328 || vcoun == 329) && (hcoun==58 || hcoun == 61)))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'h00;
				blue <= 8'hff; 
				red <= 8'h00;
			end
		end
		else if(Buffer2[16] == 0 && Buffer2[17] == 1)begin
			if(((vcoun < 331 && vcoun> 325) && hcoun == 59) ||(vcoun==329  && (hcoun==58 || hcoun== 59 || hcoun == 60)) || (hcoun == 58 && vcoun == 327))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'h00;
				blue <= 8'hff; 
				red <= 8'h00;
			end
		end
		else if(Buffer2[16] == 1 && Buffer2[17] == 0)begin
			if((vcoun == 330 && hcoun >57 && hcoun <61) || (hcoun == 59 && (vcoun == 329 || vcoun == 326)) || 	(hcoun== 60 && (vcoun == 326 || vcoun == 328))|| (vcoun == 327 && (hcoun == 61 || hcoun == 58)))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'h00;
				blue <= 8'hff; 
				red <= 8'h00;
			end
		
		end
		else if(Buffer2[16] == 1 && Buffer2[17] == 1)begin
			if(((vcoun == 327 || vcoun == 331)&&(hcoun==59 || hcoun == 60)) ||((vcoun == 328 || vcoun ==  330) && (hcoun == 58 || hcoun == 61)) || (vcoun == 329 && hcoun == 60))begin 
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
		end
			else 
			begin
				green <= 8'h00;
				blue <= 8'hff; 
				red <= 8'h00;
			end
		end
	 hcoun = hcount +60;
	 vcoun = vcount - 200;
	 end
 
 
 
 else if (hcount < 200 && hcount > 160 && vcount < 350 && vcount > 310 && Buffer3[0] == 1)begin
	 hcoun = hcount -120;
	 vcoun = vcount +0;
		if(Buffer3[1] == 0 && Buffer3[2] == 0)begin
			if(((vcoun == 330 || vcoun== 326) && (hcoun == 59 || hcoun == 60))||((vcoun==327 || vcoun==328 || vcoun == 329) && (hcoun==58 || hcoun == 61)))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'hff;
				blue <= 8'h00; 
				red <= 8'hff;
			end
		end
		else if(Buffer3[1] == 0 && Buffer3[2] == 1)begin
			if(((vcoun < 331 && vcoun> 325) && hcoun == 59) ||(vcoun==329  && (hcoun==58 || hcoun == 59 || hcoun == 60)) || (hcoun == 58 && vcoun == 327))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
			green <= 8'hff;
				blue <= 8'h00; 
				red <= 8'hff;
			end
		end
		else if(Buffer3[1] == 1 && Buffer3[2] == 0)begin
			if((vcoun == 330 && hcoun >57 && hcoun <61) || (hcoun == 59 && (vcoun == 329 || vcoun == 326)) || 	(hcoun == 60 && (vcoun == 326 || vcoun == 328))|| (vcoun == 327 && (hcoun == 61 || hcoun == 58)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'hff;
				blue <= 8'h00; 
				red <= 8'hff;
			end
		
		end
		else if(Buffer3[1] == 1 && Buffer3[2] == 1)begin
			if(((vcoun == 327 || vcoun == 331)&&(hcoun==59 || hcoun == 60)) ||((vcoun == 328 || vcoun ==  330) && (hcoun == 58 || hcoun == 61)) || (vcoun == 329 && hcoun == 60))begin 
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'hff;
				blue <= 8'h00; 
				red <= 8'hff;
			end
		end
	 hcoun = hcount +120;
	 vcoun = vcount - 0;
	 end

	
 	 else if (hcount < 200 && hcount > 160 && vcount < 310 && vcount > 270 && Buffer3[3] == 1)begin
	 hcoun = hcount -120;
	 vcoun = vcount +40;
		if(Buffer3[4] == 0 && Buffer3[5] == 0)begin
			if(((vcoun == 330 || vcoun== 326) && (hcoun == 59 || hcoun == 60))||((vcoun==327 || vcoun==328 || vcoun == 329) && (hcoun==58 || hcoun == 61)))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'hff;
				blue <= 8'h00; 
				red <= 8'hff;
			end
		end
		else if(Buffer3[4] == 0 && Buffer3[5] == 1)begin
			if(((vcoun < 331 && vcoun> 325) && hcoun == 59) ||(vcoun==329  && (hcoun==58 || hcoun == 59 || hcoun == 60)) || (hcoun == 58 && vcoun == 327))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'hff;
				blue <= 8'h00; 
				red <= 8'hff;
			end
		end
		else if(Buffer3[4] == 1 && Buffer3[5] == 0)begin
			if((vcoun == 330 && hcoun >57 && hcoun <61) || (hcoun == 59 && (vcoun == 329 || vcoun == 326)) || 	(hcoun == 60 && (vcoun == 326 || vcoun == 328))|| (vcoun == 327 && (hcoun == 61 || hcoun == 58)))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'hff;
				blue <= 8'h00; 
				red <= 8'hff;
			end
		
		end
		else if(Buffer3[4] == 1 && Buffer3[5] == 1)begin
			if(((vcoun == 327 || vcoun == 331)&&(hcoun==59 || hcoun == 60)) ||((vcoun == 328 || vcoun ==  330) && (hcoun == 58 || hcoun == 61)) || (vcoun == 329 && hcoun == 60))begin 
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'hff;
				blue <= 8'h00; 
				red <= 8'hff;
			end
		end
	 hcoun = hcount +120;
	 vcoun = vcount - 40;
	 end
	 else if (hcount < 200 && hcount > 160 && vcount < 270 && vcount > 230 && Buffer3[6] == 1)begin
	 hcoun = hcount -120;
	 vcoun = vcount +80;
		if(Buffer3[7] == 0 && Buffer3[8] == 0)begin
			if(((vcoun == 330 || vcoun== 326) && (hcoun == 59 || hcoun == 60))||((vcoun==327 || vcoun==328 || vcoun == 329) && (hcoun==58 || hcoun == 61)))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'hff;
				blue <= 8'h00; 
				red <= 8'hff;
			end
		end
		else if(Buffer3[7] == 0 && Buffer3[8] == 1)begin
			if(((vcoun < 331 && vcoun> 325) && hcoun == 59) ||(vcoun==329  && (hcoun==58 || hcoun == 59 || hcoun == 60)) || (hcoun == 58 && vcoun == 327))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'hff;
				blue <= 8'h00; 
				red <= 8'hff;
			end
		end
		else if(Buffer3[7] == 1 && Buffer3[8] == 0)begin
			if((vcoun == 330 && hcoun >57 && hcoun <61) || (hcoun == 59 && (vcoun == 329 || vcoun == 326)) || 	(hcoun == 60 && (vcoun == 326 || vcoun == 328))|| (vcoun == 327 && (hcoun == 61 || hcoun == 58)))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'hff;
				blue <= 8'h00; 
				red <= 8'hff;
			end
		
		end
		else if(Buffer3[7] == 1 && Buffer3[8] == 1)begin
			if(((vcoun == 327 || vcoun == 331)&&(hcoun==59 || hcoun == 60)) ||((vcoun == 328 || vcoun ==  330) && (hcoun == 58 || hcoun == 61)) || (vcoun == 329 && hcoun == 60))begin 
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'hff;
				blue <= 8'h00; 
				red <= 8'hff;
			end
		end
	 hcoun = hcount +120;
	 vcoun = vcount - 80;
	 end
	 else if (hcount < 200 && hcount > 160 && vcount < 230 && vcount > 190 && Buffer3[9] == 1)begin
	 hcoun = hcount -120;
	 vcoun = vcount +120;
		if(Buffer3[10] == 0 && Buffer3[11] == 0)begin
			if(((vcoun == 330 || vcoun== 326) && (hcoun == 59 || hcoun == 60))||((vcoun==327 || vcoun==328 || vcoun == 329) && (hcoun==58 || hcoun == 61)))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'hff;
				blue <= 8'h00; 
				red <= 8'hff;
			end
		end
		else if(Buffer3[10] == 0 && Buffer3[11] == 1)begin
			if(((vcoun < 331 && vcoun> 325) && hcoun == 59) ||(vcoun==329  && (hcoun==58 || hcoun == 59 || hcoun == 60)) || (hcoun == 58 && vcoun == 327))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'hff;
				blue <= 8'h00; 
				red <= 8'hff;
			end
		end
		else if(Buffer3[10] == 1 && Buffer3[11] == 0)begin
			if((vcoun == 330 && hcoun >57 && hcoun <61) || (hcoun == 59 && (vcoun == 329 || vcoun == 326)) || 	(hcoun == 60 && (vcoun == 326 || vcoun == 328))|| (vcoun == 327 && (hcoun == 61 || hcoun == 58)))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'hff;
				blue <= 8'h00; 
				red <= 8'hff;
			end
		
		end
		else if(Buffer3[10] == 1 && Buffer3[11] == 1)begin
			if(((vcoun == 327 || vcoun == 331)&&(hcoun==59 || hcoun == 60)) ||((vcoun == 328 || vcoun ==  330) && (hcoun == 58 || hcoun == 61)) || (vcoun == 329 && hcoun == 60))begin 
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'hff;
				blue <= 8'h00; 
				red <= 8'hff;
			end
		end
	 hcoun = hcount +120;
	 vcoun = vcount - 120;
	 end
	 else if (hcount < 200 && hcount > 160 && vcount < 190 && vcount > 150 && Buffer3[12] == 1)begin
	 hcoun = hcount -120;
	 vcoun = vcount +160;
		if(Buffer3[13] == 0 && Buffer3[14] == 0)begin
			if(((vcoun == 330 || vcoun== 326) && (hcoun == 59 || hcoun == 60))||((vcoun==327 || vcoun==328 || vcoun == 329) && (hcoun==58 || hcoun == 61)))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'hff;
				blue <= 8'h00; 
				red <= 8'hff;
			end
		end
		else if(Buffer3[13] == 0 && Buffer3[14] == 1)begin
			if(((vcoun < 331 && vcoun> 325) && hcoun == 59) ||(vcoun==329  && (hcoun==58 || hcoun == 59 || hcoun == 60)) || (hcoun == 58 && vcoun == 327))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'hff;
				blue <= 8'h00; 
				red <= 8'hff;
			end
		end
		else if(Buffer3[13] == 1 && Buffer3[14] == 0)begin
			if((vcoun == 330 && hcoun >57 && hcoun <61) || (hcoun == 59 && (vcoun == 329 || vcoun == 326)) || (hcoun == 60 && (vcoun == 326 || vcoun == 328))|| (vcoun == 327 && (hcoun == 61 || hcoun == 58)))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'hff;
				blue <= 8'h00; 
				red <= 8'hff;
			end
		
		end
		else if(Buffer3[13] == 1 && Buffer3[14] == 1)begin
			if(((vcoun == 327 || vcoun == 331)&&(hcoun==59 || hcoun == 60)) ||((vcoun == 328 || vcoun ==  330) && (hcoun == 58 || hcoun == 61)) || (vcoun == 329 && hcoun == 60))begin 
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'hff;
				blue <= 8'h00; 
				red <= 8'hff;
			end
		end
	 hcoun = hcount +120;
	 vcoun = vcount - 160;
	 end
	 else if (hcount < 200 && hcount > 160 && vcount < 150 && vcount > 110 && Buffer3[15] == 1)begin
	 hcoun = hcount -120;
	 vcoun = vcount +200;
		if(Buffer3[16] == 0 && Buffer3[17] == 0)begin
			if(((vcoun == 330 || vcoun== 326) && (hcoun == 59 || hcoun == 60))||((vcoun==327 || vcoun==328 || vcoun == 329) && (hcoun==58 || hcoun == 61)))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'hff;
				blue <= 8'h00; 
				red <= 8'hff;
			end
		end
		else if(Buffer3[16] == 0 && Buffer3[17] == 1)begin
			if(((vcoun < 331 && vcoun> 325) && hcoun == 59) ||(vcoun==329  && (hcoun==58 || hcoun == 59 || hcoun == 60)) || (hcoun == 58 && vcoun == 327))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'hff;
				blue <= 8'h00; 
				red <= 8'hff;
			end
		end
		else if(Buffer3[16] == 1 && Buffer3[17] == 0)begin
			if((vcoun == 330 && hcoun >57 && hcoun <61) || (hcoun == 59 && (vcoun == 329 || vcoun == 326)) || 	(hcoun == 60 && (vcoun == 326 || vcoun == 328))|| (vcoun == 327 && (hcoun == 61 || hcoun == 58)))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'hff;
				blue <= 8'h00; 
				red <= 8'hff;
			end
		
		end
		else if(Buffer3[16] == 1 && Buffer3[17] == 1)begin
			if(((vcoun == 327 || vcoun == 331)&&(hcoun==59 || hcoun == 60)) ||((vcoun == 328 || vcoun ==  330) && (hcoun == 58 || hcoun == 61)) || (vcoun == 329 && hcoun == 60))begin 
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'hff;
				blue <= 8'h00; 
				red <= 8'hff;
			end
		end
	 hcoun = hcount +120;
	 vcoun = vcount - 200;
	 end
	 else if (hcount < 260 && hcount > 220 && vcount < 350 && vcount > 310 && Buffer4[0] == 1)begin
	 hcoun = hcount -180;
	 vcoun = vcount +0;
		if(Buffer4[1] == 0 && Buffer4[2] == 0)begin
			if(((vcoun == 330 || vcoun== 326) && (hcoun == 59 || hcoun == 60))||((vcoun==327 || vcoun==328 || vcoun == 329) && (hcoun==58 || hcoun == 61)))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'hff;
				blue <= 8'h00; 
				red <= 8'h00;
			end
		end
		else if(Buffer4[1] == 0 && Buffer4[2] == 1)begin
			if(((vcoun < 331 && vcoun> 325) && hcoun == 59) ||(vcoun==329  && (hcoun==58 || hcoun == 59 || hcoun == 60)) || (hcoun == 58 && vcoun == 327))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'hff;
				blue <= 8'h00; 
				red <= 8'h00;
			end
		end
		else if(Buffer4[1] == 1 && Buffer4[2] == 0)begin
			if((vcoun == 330 && hcoun >57 && hcoun <61) || (hcoun == 59 && (vcoun == 329 || vcoun == 326)) || 	(hcoun == 60 && (vcoun == 326 || vcoun == 328))|| (vcoun == 327 && (hcoun == 61 || hcoun == 58)))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'hff;
				blue <= 8'h00; 
				red <= 8'h00;
			end
		
		end
		else if(Buffer4[1] == 1 && Buffer4[2] == 1)begin
			if(((vcoun == 327 || vcoun == 331)&&(hcoun==59 || hcoun == 60)) ||((vcoun == 328 || vcoun ==  330) && (hcoun == 58 || hcoun == 61)) || (vcoun == 329 && hcoun == 60))begin 
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'hff;
				blue <= 8'h00; 
				red <= 8'h00;
			end
		end
	 hcoun = hcount +180;
	 vcoun = vcount - 0;
	 end

 
    else if (hcount < 260 && hcount > 220 && vcount < 310 && vcount > 270 && Buffer4[3] == 1)begin
	 hcoun = hcount -180;
	 vcoun = vcount +40;
		if(Buffer4[4] == 0 && Buffer4[5] == 0)begin
			if(((vcoun == 330 || vcoun== 326) && (hcoun == 59 || hcoun == 60))||((vcoun==327 || vcoun==328 || vcoun == 329) && (hcoun==58 || hcoun == 61)))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'hff;
				blue <= 8'h00; 
				red <= 8'h00;
			end
		end
		else if(Buffer4[4] == 0 && Buffer4[5] == 1)begin
			if(((vcoun < 331 && vcoun> 325) && hcoun == 59) ||(vcoun==329  && (hcoun==58 || hcoun == 59 || hcoun == 60)) || (hcoun == 58 && vcoun == 327))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'hff;
				blue <= 8'h00; 
				red <= 8'h00;
			end
		end
		else if(Buffer4[4] == 1 && Buffer4[5] == 0)begin
			if((vcoun == 330 && hcoun >57 && hcoun <61) || (hcoun == 59 && (vcoun == 329 || vcoun == 326)) || (hcoun == 60 && (vcoun == 326 || vcoun == 328))|| (vcoun == 327 && (hcoun == 61 || hcoun == 58)))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'hff;
				blue <= 8'h00; 
				red <= 8'h00;
			end
		
		end
		else if(Buffer4[4] == 1 && Buffer4[5] == 1)begin
			if(((vcoun == 327 || vcoun == 331)&&(hcoun==59 || hcoun == 60)) ||((vcoun == 328 || vcoun ==  330) && (hcoun == 58 || hcoun == 61)) || (vcoun == 329 && hcoun == 60))begin 
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'hff;
				blue <= 8'h00; 
				red <= 8'h00;
			end
		end
	 hcoun = hcount +180;
	 vcoun = vcount - 40;
	 end
	 else if (hcount < 260 && hcount > 220 && vcount < 270 && vcount > 230 && Buffer4[6] == 1)begin
	 hcoun = hcount -180;
	 vcoun = vcount +80;
		if(Buffer4[7] == 0 && Buffer4[8] == 0)begin
			if(((vcoun == 330 || vcoun== 326) && (hcoun == 59 || hcoun == 60))||((vcoun==327 || vcoun==328 || vcoun == 329) && (hcoun==58 || hcoun == 61)))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'hff;
				blue <= 8'h00; 
				red <= 8'h00;
			end
		end
		else if(Buffer4[7] == 0 && Buffer4[8] == 1)begin
			if(((vcoun < 331 && vcoun> 325) && hcoun == 59) ||(vcoun==329  && (hcoun==58 || hcoun == 59 || hcoun == 60)) || (hcoun == 58 && vcoun == 327))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'hff;
				blue <= 8'h00; 
				red <= 8'h00;
			end
		end
		else if(Buffer4[7] == 1 && Buffer4[8] == 0)begin
			if((vcoun == 330 && hcoun >57 && hcoun <61) || (hcoun == 59 && (vcoun == 329 || vcoun == 326)) || 	(hcoun == 60 && (vcoun == 326 || vcoun == 328))|| (vcoun == 327 && (hcoun == 61 || hcoun == 58)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'hff;
				blue <= 8'h00; 
				red <= 8'h00;
			end
		
		end
		else if(Buffer4[7] == 1 && Buffer4[8] == 1)begin
			if(((vcoun == 327 || vcoun == 331)&&(hcoun==59 || hcoun == 60)) ||((vcoun == 328 || vcoun ==  330) && (hcoun == 58 || hcoun == 61)) || (vcoun == 329 && hcoun == 60))begin 
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'hff;
				blue <= 8'h00; 
				red <= 8'h00;
			end
		end
	 hcoun = hcount +180;
	 vcoun = vcount - 80;
	 end
	 else if (hcount < 260 && hcount > 220 && vcount < 230 && vcount > 190 && Buffer4[9] == 1)begin
	 hcoun = hcount -180;
	 vcoun = vcount +120;
		if(Buffer4[10] == 0 && Buffer4[11] == 0)begin
			if(((vcoun == 330 || vcoun== 326) && (hcoun == 59 || hcoun == 60))||((vcoun==327 || vcoun==328 || vcoun == 329) && (hcoun==58 || hcoun == 61)))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'hff;
				blue <= 8'h00; 
				red <= 8'h00;
			end
		end
		else if(Buffer4[10] == 0 && Buffer4[11] == 1)begin
			if(((vcoun < 331 && vcoun> 325) && hcoun == 59) ||(vcoun==329  && (hcoun==58 || hcoun == 59 || hcoun == 60)) || (hcoun == 58 && vcoun == 327))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'hff;
				blue <= 8'h00; 
				red <= 8'h00;
			end
		end
		else if(Buffer4[10] == 1 && Buffer4[11] == 0)begin
			if((vcoun == 330 && hcoun >57 && hcoun <61) || (hcoun == 59 && (vcoun == 329 || vcoun == 326)) || (hcoun == 60 && (vcoun == 326 || vcoun == 328))|| (vcoun == 327 && (hcoun == 61 || hcoun == 58)))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'hff;
				blue <= 8'h00; 
				red <= 8'h00;
			end
		
		end
		else if(Buffer4[10] == 1 && Buffer4[11] == 1)begin
			if(((vcoun == 327 || vcoun == 331)&&(hcoun==59 || hcoun == 60)) ||((vcoun == 328 || vcoun==  330) && (hcoun == 58 || hcoun == 61)) || (vcoun == 329 && hcoun == 60))begin 
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'hff;
				blue <= 8'h00; 
				red <= 8'h00;
			end
		end
	 hcoun = hcount +180;
	 vcoun = vcount - 120;
	 end
	 else if (hcount < 260 && hcount > 220 && vcount < 190 && vcount > 150 && Buffer4[12] == 1)begin
	 hcoun= hcount -180;
	 vcoun = vcount +160;
		if(Buffer4[13] == 0 && Buffer4[14] == 0)begin
			if(((vcoun == 330 || vcoun== 326) && (hcoun == 59 || hcoun == 60))||((vcoun==327 || vcoun==328 || vcoun == 329) && (hcoun==58 || hcoun == 61)))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'hff;
				blue <= 8'h00; 
				red <= 8'h00;
			end
		end
		else if(Buffer4[13] == 0 && Buffer4[14] == 1)begin
			if(((vcoun < 331 && vcoun> 325) && hcoun == 59) ||(vcoun==329  && (hcoun==58 || hcoun == 59 || hcoun == 60)) || (hcoun == 58 && vcoun == 327))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'hff;
				blue <= 8'h00; 
				red <= 8'h00;
			end
		end
		else if(Buffer4[13] == 1 && Buffer4[14] == 0)begin
			if((vcoun == 330 && hcoun >57 && hcoun <61) || (hcoun == 59 && (vcoun == 329 || vcoun == 326)) || (hcoun == 60 && (vcoun == 326 || vcoun == 328))|| (vcoun == 327 && (hcoun == 61 || hcoun == 58)))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'hff;
				blue <= 8'h00; 
				red <= 8'h00;
			end
		
		end
		else if(Buffer4[13] == 1 && Buffer4[14] == 1)begin
			if(((vcoun == 327 || vcoun == 331)&&(hcoun==59 || hcoun == 60)) ||((vcoun == 328 || vcoun ==  330) && (hcoun == 58 || hcoun == 61)) || (vcoun == 329 && hcoun == 60))begin 
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'hff;
				blue <= 8'h00; 
				red <= 8'h00;
			end
		end
	 hcoun = hcount +180;
	 vcoun = vcount - 160;
	 end
	 else if (hcount < 260 && hcount > 220 && vcount < 150 && vcount > 110 && Buffer4[15] == 1)begin
	 hcoun = hcount -180;
	 vcoun = vcount +200;
		if(Buffer4[16] == 0 && Buffer4[17] == 0)begin
			if(((vcoun == 330 || vcoun== 326) && (hcoun == 59 || hcoun == 60))||((vcoun==327 || vcoun==328 || vcoun == 329) && (hcoun==58 || hcoun == 61)))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'hff;
				blue <= 8'h00; 
				red <= 8'h00;
			end
		end
		else if(Buffer4[16] == 0 && Buffer4[17] == 1)begin
			if(((vcoun < 331 && vcoun> 325) && hcoun == 59) ||(vcoun==329  && (hcoun==58 || hcoun == 59 || hcoun == 60)) || (hcoun == 58 && vcoun == 327))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else 
			begin
				green <= 8'hff;
				blue <= 8'h00; 
				red <= 8'h00;
			end
		end
		else if(Buffer4[16] == 1 && Buffer4[17] == 0)begin
		if((vcoun == 330 && hcoun >57 && hcoun <61) || (hcoun == 59 && (vcoun == 329 || vcoun == 326)) || (hcoun == 60 && (vcoun == 326 || vcoun == 328))|| (vcoun == 327 && (hcoun == 61 || hcoun == 58)))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
		end
			else 
			begin
				green <= 8'hff;
				blue <= 8'h00; 
				red <= 8'h00;
			end
		
		end
		else if(Buffer4[16] == 1 && Buffer4[17] == 1)begin
		if(((vcoun == 327 || vcoun == 331)&&(hcoun==59 || hcoun == 60)) ||((vcoun == 328 || vcoun ==  330) && (hcoun == 58 || hcoun == 61)) || (vcoun == 329 && hcoun == 60))begin 
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
		end
			else 
			begin
				green <= 8'hff;
				blue <= 8'h00; 
				red <= 8'h00;
			end
		end
	 hcoun = hcount +180;
	 vcoun = vcount - 200;
	 end


	 // output data
      
		else if((outputdata[0] == 0)&&(((vcount==73 || vcount==77 )&& (hcount == 123 || hcount==124)) || ((hcount == 125 || hcount==122)&&(vcount<77 && vcount>73))))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
		
	  
		else	if((outputdata[1] == 0)&&(((vcount==73 || vcount==77 )&& (hcount == 133 || hcount==134)) || ((hcount == 135 || hcount==132)&&(vcount<77 && vcount>73))))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
	
	
			else if((outputdata[2] == 0)&&(((vcount==73 || vcount==77 )&& (hcount == 143 || hcount==144)) || ((hcount == 145 || hcount==142)&&(vcount<77 && vcount>73))))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
		
	  
			else if((outputdata[3] == 0)&&(((vcount==73 || vcount==77 )&& (hcount == 153 || hcount==154)) || ((hcount == 155 || hcount==152)&&(vcount<77 && vcount>73))))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
		
   
		else if((outputdata[0] == 1)&&((vcount==77 && hcount<125 && hcount>121) || (hcount == 123 && vcount>72 && vcount<77) || (hcount == 122 && vcount == 74)))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
		
			else if((outputdata[1] == 1)&&((vcount==77 && hcount<135 && hcount>131) || (hcount == 133 && vcount>72 && vcount<77) || (hcount == 132 && vcount == 74)))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
		
	
			else if((outputdata[2] == 1)&&((vcount==77 && hcount<145 && hcount>141) || (hcount == 143 && vcount>72 && vcount<77) || (hcount == 142 && vcount == 74)))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
		
			else if((outputdata[3] == 1)&&((vcount==77 && hcount<155 && hcount>151) || (hcount == 153 && vcount>72 && vcount<77) || (hcount == 152 && vcount == 74)))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
			end
			else begin
							green <= 8'hff;
				blue <= 8'hff; 
				red <= 8'hff;
			end
		end
		else if ((hcount>270&& hcount<550 &&vcount < 460 && vcount>100))begin
	
	 
	 
   
	  if(vcount<127 && vcount>119 && hcount == 404)begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	 end	
	 else if(((vcount==120 || vcount==123 || vcount == 126)&& hcount>444 && hcount<450) || 	((vcount == 122 || vcount == 121)&& hcount == 449) || ((vcount == 124 || vcount == 125)&& hcount == 445))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	 end
	 else if((hcount == 484 && vcount <127 && vcount > 119)||((vcount == 120|| vcount == 123 || vcount==126)&& hcount<485 && hcount > 479))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	 end
	 else if((vcount<127&& vcount>119&& hcount == 524)||(vcount == 123&& hcount > 519 && hcount < 525)||(hcount==520&& vcount>119&& vcount<124))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	 end
	 else if((vcount < 191 && vcount > 172 && hcount == 324) || (vcount == 173 && hcount < 331 && hcount > 317))begin
	 	green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	 end
	 else if((hcount == 323 && vcount < 251 && vcount > 233) || (vcount == 233 && hcount < 334 && hcount > 323) || (hcount == 333 && vcount < 241 && vcount > 233))begin
	 	green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	 end
	 else if((hcount == 333 && vcount < 321 && vcount > 291) || ((vcount == 308 || vcount == 320) && hcount < 334 && hcount > 319) || (hcount == 320 && vcount < 321 && vcount > 307))begin
	 	green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	 end
	 else if(read_data1 % 10 == 0 &&(((hcount == 410 || hcount== 414) && vcount < 247 && vcount >240) || ((vcount == 246 || vcount == 240) && hcount<414 && hcount > 410)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
	else if(read_data2 % 10 == 0 && (((hcount == 450 || hcount== 454) && vcount < 247 && vcount >240) || ((vcount == 246 || vcount == 240) && hcount<454 && hcount > 450)))begin
    
      green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
    end
	

	else if(read_data3 % 10 == 0 && (((hcount == 490 || hcount== 494) && vcount < 247 && vcount >240) || ((vcount == 246 || vcount == 240) && hcount<494 && hcount > 490)))begin
    
      green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
    
	end

	else if(read_data4 % 10 == 0 && (((hcount == 530  || hcount== 534) && vcount < 247 && vcount >240) || ((vcount == 246 || vcount == 240) && hcount<534 && hcount > 530)))begin
    
      green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
    
	end
	// -65 vcount starts

else if(wrote_data1 % 10 == 0 && (((hcount == 410 || hcount== 414) && vcount < 182 && vcount >175) || ((vcount == 181 || vcount == 175) && hcount<414 && hcount > 410)))
begin 
       green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
end

else if(wrote_data2 % 10 == 0 && (((hcount == 450 || hcount== 454) && vcount < 182 && vcount >175) || ((vcount == 181 || vcount == 175) && hcount<454 && hcount > 450)))
begin
        green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
end

else if(wrote_data3 % 10 == 0 && (((hcount == 490 ||  hcount== 494) && vcount < 182 && vcount >175) || ((vcount == 181 || vcount == 175) && hcount<494 && hcount > 490)))
begin
        green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
end

else if(wrote_data4 % 10 == 0 && (((hcount == 530 || hcount== 534) && vcount < 182 && vcount >175) || ((vcount == 181 || vcount == 175) && hcount<534 && hcount > 530)))
begin
        green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
end

// +65 vcount starts

else if(loss_data1 % 10 == 0 && (((hcount == 410 || hcount== 414) && vcount < 312	 && vcount >305) || ((vcount == 311 || vcount == 305) && hcount<414 && hcount > 410)))
begin
        green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
end


else if(loss_data2 % 10 == 0 && (((hcount == 450 || hcount== 454) && vcount < 312 && vcount >305) || ((vcount == 311 || vcount == 305) && hcount<454 && hcount > 450)))
begin
        green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
end


else if(loss_data3 % 10 == 0 && (((hcount == 490 || hcount== 494) && vcount < 312 && vcount >305) || ((vcount == 311 || vcount == 305) && hcount<494 && hcount > 490) ))
begin
        green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
end


else if(loss_data4 % 10 == 0 && (((hcount == 530 || hcount== 534) && vcount < 312 && vcount >305) || ((vcount == 311 || vcount == 305) && hcount<534 && hcount > 530) ))
begin
       green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
end

//1

		// vcount starts

else if(read_data1 % 10 == 1 &&(vcount<247 && vcount>239 && hcount == 414))
begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
end

else if(read_data2 % 10 == 1 &&(vcount<247 && vcount>239 && hcount == 454))
begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
end

else if(read_data3 % 10 == 1 &&(vcount<247 && vcount>239 && hcount == 494))
begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
end

else if(read_data4 % 10 == 1 &&(vcount<247 && vcount>239 && hcount == 534))
begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
end


// vcount -65 starts

else if(wrote_data1 % 10 == 1 &&(vcount<182 && vcount>174 && hcount == 414))
begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
end

else if(wrote_data2 % 10 == 1 &&(vcount<182 && vcount>174 && hcount == 454))
begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
end

else if(wrote_data3 % 10 == 1 &&(vcount<182 && vcount>174 && hcount == 494))
begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
end

else if(wrote_data4 % 10 == 1 &&(vcount<182 && vcount>174 && hcount == 534))
begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
end


// vcount +65 starts

else if(loss_data1 % 10 == 1 &&(vcount<312 && vcount>304 && hcount == 414))
begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
end

else if(loss_data2 % 10 == 1 &&(vcount<312 && vcount>304 && hcount == 454))
begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
end


else if(loss_data3 % 10 == 1 &&(vcount<312 && vcount>304 && hcount == 494))
begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
end


else if(loss_data4 % 10 == 1 &&(vcount<312 && vcount>304 && hcount == 534))
begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
end

// 2
	else if(read_data1 % 10 == 2 &&(((vcount==240 || vcount==243 || vcount == 246)&& hcount>409 && hcount<415) || ((vcount == 242 || vcount == 241)&& hcount == 414) || ((vcount == 244 || vcount == 245)&& hcount == 410)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
	
else if(read_data2 % 10 == 2 &&(((vcount==240 || vcount==243 || vcount == 246)&& hcount>449 && hcount<455) || ((vcount == 242 || vcount == 241)&& hcount == 454) || ((vcount == 244 || vcount == 245)&& hcount == 450)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
else if(read_data3 % 10 == 2 &&(((vcount==240 || vcount==243 || vcount == 246)&& hcount>489 && hcount<495) || ((vcount == 242 || vcount == 241)&& hcount == 494) || ((vcount == 244 || vcount == 245)&& hcount == 490)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
else if(read_data4 % 10 == 2 &&(((vcount==240 || vcount==243 || vcount == 246)&& hcount>529 && hcount<535) || ((vcount == 242 || vcount == 241)&& hcount == 534) || ((vcount == 244 || vcount == 245)&& hcount == 530)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
	
// vcount -65

else if(wrote_data1 % 10 == 2 &&(((vcount==175 || vcount==178 || vcount == 181)&& hcount>409 && hcount<415) || ((vcount == 177 || vcount == 176)&& hcount == 414) || ((vcount == 179 || vcount == 180)&& hcount == 410)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
else if(wrote_data2 % 10 == 2 &&(((vcount==175 || vcount==178 || vcount == 181)&& hcount>449 && hcount<455) || ((vcount == 177 || vcount == 176)&& hcount == 454) || ((vcount == 179 || vcount == 180)&& hcount == 450)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
else if(wrote_data3 % 10 == 2 &&(((vcount==175 || vcount==178 || vcount == 181)&& hcount>489 && hcount<495) || ((vcount == 177 || vcount == 176)&& hcount == 494) || ((vcount == 179 || vcount == 180)&& hcount == 490)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
else if(wrote_data4 % 10 == 2 &&(((vcount==175 || vcount==178 || vcount == 181)&& hcount>529 && hcount<535) || ((vcount == 177 || vcount == 176)&& hcount == 534) || ((vcount == 179 || vcount == 180)&& hcount == 530)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
	
// vcount +65
	
else if(loss_data1 % 10 == 2 &&(((vcount==305 || vcount==308 || vcount == 311)&& hcount>409 && hcount<415) || ((vcount == 307 || vcount == 306)&& hcount == 414) || ((vcount == 309 || vcount == 310)&& hcount == 410)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
else if(loss_data2 % 10 == 2 &&(((vcount==305 || vcount==308 || vcount == 311)&& hcount>449 && hcount<455) || ((vcount == 307 || vcount == 306)&& hcount == 454) || ((vcount == 309 || vcount == 310)&& hcount == 450)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
else if(loss_data3 % 10 == 2 &&(((vcount==305 || vcount==308 || vcount == 311)&& hcount>489 && hcount<495) || ((vcount == 307 || vcount == 306)&& hcount == 494) || ((vcount == 309 || vcount == 310)&& hcount == 490)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
else if(loss_data4 % 10 == 2 &&(((vcount==305 || vcount==308 || vcount == 311)&& hcount>529 && hcount<535) || ((vcount == 307 || vcount == 306)&& hcount == 534) || ((vcount == 309 || vcount == 310)&& hcount == 530)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end

// 3
	else if(read_data1 % 10 == 3 &&((hcount == 414 && vcount <247 && vcount > 239)||((vcount == 240|| vcount == 243 || vcount==246)&& hcount<415 && hcount > 409)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
	// vcount starts

else if(read_data1 % 10 == 3 &&((hcount == 414 && vcount <247 && vcount > 239)||((vcount == 240|| vcount == 243 || vcount==246)&& hcount<415 && hcount > 409)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
	else if(read_data2 % 10 == 3 &&((hcount == 454 && vcount <247 && vcount > 239)||((vcount == 240|| vcount == 243 || vcount==246)&& hcount<455 && hcount > 449)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
	else if(read_data3 % 10 == 3 &&((hcount == 494 && vcount <247 && vcount > 239)||((vcount == 240|| vcount == 243 || vcount==246)&& hcount<495 && hcount > 489)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
	else if(read_data4 % 10 == 3 &&((hcount == 534 && vcount <247 && vcount > 239)||((vcount == 240|| vcount == 243 || vcount==246)&& hcount<535 && hcount > 529)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
// vcount -65
	
else if(wrote_data1 % 10 == 3 &&((hcount == 414 && vcount <182 && vcount > 174)||((vcount == 175|| vcount == 178 || vcount==181)&& hcount<415 && hcount > 409)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
	else if(wrote_data2 % 10 == 3 &&((hcount == 454 && vcount <182 && vcount > 174)||((vcount == 175|| vcount == 178 || vcount==181)&& hcount<455 && hcount > 449)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
	else if(wrote_data3 % 10 == 3 &&((hcount == 494 && vcount <182 && vcount > 174)||((vcount == 175|| vcount == 178 || vcount==181)&& hcount<495 && hcount > 489)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
	else if(wrote_data4 % 10 == 3 &&((hcount == 534 && vcount <182 && vcount > 174)||((vcount == 175|| vcount == 178 || vcount==181)&& hcount<535 && hcount > 529)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end

// vcount +65

else if(loss_data1 % 10 == 3 &&((hcount == 414 && vcount <312 && vcount > 304)||((vcount == 305|| vcount == 308 || vcount==311)&& hcount<415 && hcount > 409)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
	else if(loss_data2 % 10 == 3 &&((hcount == 454 && vcount <312 && vcount > 304)||((vcount == 305|| vcount == 308 || vcount==311)&& hcount<455 && hcount > 449)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
	else if(loss_data3 % 10 == 3 &&((hcount == 494 && vcount <312 && vcount > 304)||((vcount == 305|| vcount == 308 || vcount==311)&& hcount<495 && hcount > 489)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
	else if(loss_data4 % 10 == 3 &&((hcount == 534 && vcount <312 && vcount > 304)||((vcount == 305|| vcount == 308 || vcount==311)&& hcount<535 && hcount > 529)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end

// 4
	else if(read_data1 % 10 == 4 &&((vcount<247&& vcount>239&& hcount == 414)||(vcount == 243&& hcount > 409 && hcount < 415)||(hcount==410&& vcount>239&& vcount<244)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	// vcount starts

else if(read_data1 % 10 == 4 &&((vcount<247&& vcount>239&& hcount == 414)||(vcount == 243&& hcount > 409 && hcount < 415)||(hcount==410&& vcount>239&& vcount<244)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
	else if(read_data2 % 10 == 4 &&((vcount<247&& vcount>239&& hcount == 454)||(vcount == 243&& hcount > 449 && hcount < 455)||(hcount==450&& vcount>239&& vcount<244)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
	else if(read_data3 % 10 == 4 &&((vcount<247&& vcount>239&& hcount == 494)||(vcount == 243&& hcount > 489 && hcount < 495)||(hcount==490&& vcount>239&& vcount<244)))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
	
	else if(read_data4 % 10 == 4 &&((vcount<247&& vcount>239&& hcount == 534)||(vcount == 243&& hcount > 529 && hcount < 535)||(hcount==530&& vcount>239&& vcount<244)))begin
				green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
// vcount -65

else if(wrote_data1 % 10 == 4 &&((vcount<182&& vcount>174&& hcount == 414)||(vcount == 178&& hcount > 409 && hcount < 415)||(hcount==410&& vcount>174&& vcount<179)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
	else if(wrote_data2 % 10 == 4 &&((vcount<182&& vcount>174&& hcount == 454)||(vcount == 178&& hcount > 449 && hcount < 455)||(hcount==450&& vcount>174&& vcount<179)))begin
	green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
	else if(wrote_data3 % 10 == 4 &&((vcount<182&& vcount>174&& hcount == 494)||(vcount == 178&& hcount > 489 && hcount < 495)||(hcount==490&& vcount>174&& vcount<179)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
	
	else if(wrote_data4 % 10 == 4 &&((vcount<182&& vcount>174&& hcount == 534)||(vcount == 178&& hcount > 529 && hcount < 535)||(hcount==530&& vcount>174&& vcount<179)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	else if(loss_data1 % 10 == 4 &&((vcount<312&& vcount>304&& hcount == 414)||(vcount == 308&& hcount > 409 && hcount < 415)||(hcount==410&& vcount>304&& vcount<309)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
	else if(loss_data2 % 10 == 4 &&((vcount<312&& vcount>304&& hcount == 454)||(vcount == 308&& hcount > 449 && hcount < 455)||(hcount==450&& vcount>304&& vcount<309)))begin
	green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
	else if(loss_data3 % 10 == 4 &&((vcount<312&& vcount>304&& hcount == 494)||(vcount == 308&& hcount > 489 && hcount < 495)||(hcount==490&& vcount>304&& vcount<309)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
	
	else if(loss_data4 % 10 == 4 &&((vcount<312&& vcount>304&& hcount == 534)||(vcount == 308&& hcount > 529 && hcount < 535)||(hcount==530&& vcount>304&& vcount<309)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end

// 5

	// vcount starts

else if(read_data1 % 10 == 5 && (((vcount==240 || vcount==243 || vcount == 246)&& hcount>409 && hcount<415) || (hcount == 410 && vcount < 243 && vcount > 240) || (hcount == 414 && vcount < 246 && vcount > 243)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
	else if(read_data2 % 10 == 5 && (((vcount==240 || vcount==243 || vcount == 246)&& hcount>449 && hcount<455) || (hcount == 450 && vcount < 243 && vcount > 240) || (hcount == 454 && vcount < 246 && vcount > 243)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
	else if(read_data3 % 10 == 5 && (((vcount==240 || vcount==243 || vcount == 246)&& hcount>489 && hcount<495) || (hcount == 490 && vcount < 243 && vcount > 240) || (hcount == 494 && vcount < 246 && vcount > 243)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
	else if(read_data4 % 10 == 5 && (((vcount==240 || vcount==243 || vcount == 246)&& hcount>529 && hcount<535) || (hcount == 530 && vcount < 243 && vcount > 240) || (hcount == 534 && vcount < 246 && vcount > 243)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
// vcount -65
	
	else if(wrote_data1 % 10 == 5 && (((vcount==175 || vcount==178 || vcount == 181)&& hcount>409 && hcount<415) || (hcount == 410 && vcount < 178 && vcount > 175) || (hcount == 414 && vcount < 181 && vcount > 178)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
	else if(wrote_data2 % 10 == 5 && (((vcount==175 || vcount==178 || vcount == 181)&& hcount>449 && hcount<455) || (hcount == 450 && vcount < 178 && vcount > 175) || (hcount == 454 && vcount < 181 && vcount > 178)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
	else if(wrote_data3 % 10 == 5 && (((vcount==175 || vcount==178 || vcount == 181)&& hcount>489 && hcount<495) || (hcount == 490 && vcount < 178 && vcount > 175) || (hcount == 494 && vcount < 181 && vcount > 178)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
	else if(wrote_data4 % 10 == 5 && (((vcount==175 || vcount==178 || vcount == 181)&& hcount>529 && hcount<535) || (hcount == 530 && vcount < 178 && vcount > 175) || (hcount == 534 && vcount < 181 && vcount > 178)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
// vcount +65
	
	else if(loss_data1 % 10 == 5 && (((vcount==305 || vcount==308 || vcount == 311)&& hcount>409 && hcount<415) || (hcount == 410 && vcount < 308 && vcount > 305) || (hcount == 414 && vcount < 311 && vcount > 308)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
	else if(loss_data2 % 10 == 5 && (((vcount==305 || vcount==308 || vcount == 311)&& hcount>449 && hcount<455) || (hcount == 450 && vcount < 308 && vcount > 305) || (hcount == 454 && vcount < 311 && vcount > 308)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
	else if(loss_data3 % 10 == 5 && (((vcount==305 || vcount==308 || vcount == 311)&& hcount>489 && hcount<495) || (hcount == 490 && vcount < 308 && vcount > 305) || (hcount == 494 && vcount < 311 && vcount > 308)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
	else if(loss_data4 % 10 == 5 && (((vcount==305 || vcount==308 || vcount == 311)&& hcount>529 && hcount<535) || (hcount == 530 && vcount < 308 && vcount > 305) || (hcount == 534 && vcount < 311 && vcount > 308)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
// 6
	else if(read_data1 % 10 == 6 && (((vcount==240 || vcount==243 || vcount == 246)&& hcount>409 && hcount<415) || (vcount<246 && vcount>243 && hcount == 414) || (hcount == 410 && vcount < 247 && vcount > 240)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
	else if(read_data2 % 10 == 6 && (((vcount==240 || vcount==243 || vcount == 246)&& hcount>449 && hcount<455) || (vcount<246 && vcount>243 && hcount == 454) || (hcount == 450 && vcount < 247 && vcount > 240)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
	else if(read_data3 % 10 == 6 && (((vcount==240 || vcount==243 || vcount == 246)&& hcount>489 && hcount<495) || (vcount<246 && vcount>243 && hcount == 494) || (hcount == 490 && vcount < 247 && vcount > 240)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
	else if(read_data4 % 10 == 6 && (((vcount==240 || vcount==243 || vcount == 246)&& hcount>529 && hcount<535) || (vcount<246 && vcount>243 && hcount == 534) || (hcount == 530 && vcount < 247 && vcount > 240)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
	//vcount -65
	
	else if(wrote_data1 % 10 == 6 && (((vcount==175 || vcount==178 || vcount == 181)&& hcount>409 && hcount<415) || (vcount<181 && vcount>178 && hcount == 414) || (hcount == 410 && vcount < 182 && vcount > 175)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
	else if(wrote_data2 % 10 == 6 && (((vcount==175 || vcount==178 || vcount == 181)&& hcount>449 && hcount<455) || (vcount<181 && vcount>178 && hcount == 454) || (hcount == 450 && vcount < 182 && vcount > 175)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
	else if(wrote_data3 % 10 == 6 && (((vcount==175 || vcount==178 || vcount == 181)&& hcount>489 && hcount<495) || (vcount<181 && vcount>178 && hcount == 494) || (hcount == 490 && vcount < 182 && vcount > 175)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
	else if(wrote_data4 % 10 == 6 && (((vcount==175 || vcount==178 || vcount == 181)&& hcount>529 && hcount<535) || (vcount<181 && vcount>178 && hcount == 534) || (hcount == 530 && vcount < 182 && vcount > 175)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
	// count +65
	
	else if(loss_data1 % 10 == 6 && (((vcount==305 || vcount==308 || vcount == 311)&& hcount>409 && hcount<415) || (vcount<312 && vcount>308 && hcount == 414) || (hcount == 410 && vcount < 311 && vcount > 305)))begin
	green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
	else if(loss_data2 % 10 == 6 && (((vcount==305 || vcount==308 || vcount == 311)&& hcount>449 && hcount<455) || (vcount<312 && vcount>308 && hcount == 454) || (hcount == 450 && vcount < 311 && vcount > 305)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
	else if(loss_data3 % 10 == 6 && (((vcount==305 || vcount==308 || vcount == 311)&& hcount>489 && hcount<495) || (vcount<312 && vcount>308 && hcount == 494) || (hcount == 490 && vcount < 311 && vcount > 305)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
	else if(loss_data4 % 10 == 6 && (((vcount==305 || vcount==308 || vcount == 311)&& hcount>529 && hcount<535) || (vcount<312 && vcount>308 && hcount == 534) || (hcount == 530 && vcount < 311 && vcount > 305)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
// 7
	else if(read_data1 % 10 == 7 && ((vcount<247 && vcount>239 && hcount == 414)|| (vcount == 240 && hcount > 409 && hcount < 415)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
	else if(read_data2 % 10 == 7 && ((vcount<247 && vcount>239 && hcount == 454)|| (vcount == 240 && hcount > 449 && hcount < 455)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
	else if(read_data3 % 10 == 7 && ((vcount<247 && vcount>239 && hcount == 494)|| (vcount == 240 && hcount > 489 && hcount < 495)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
	else if(read_data4 % 10 == 7 && ((vcount<247 && vcount>239 && hcount == 534)|| (vcount == 240 && hcount > 529 && hcount < 535)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
	
	//vcount -65
	
	else if(wrote_data1 % 10 == 7 && ((vcount<182 && vcount>174 && hcount == 414)|| (vcount == 175 && hcount > 409 && hcount < 415)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
	else if(wrote_data2 % 10 == 7 && ((vcount<182 && vcount>174 && hcount == 454)|| (vcount == 175 && hcount > 449 && hcount < 455)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
	else if(wrote_data3 % 10 == 7 && ((vcount<182 && vcount>174 && hcount == 494)|| (vcount == 175 && hcount > 489 && hcount < 495)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
	else if(wrote_data4 % 10 == 7 && ((vcount<182 && vcount>174 && hcount == 534)|| (vcount == 175 && hcount > 529 && hcount < 535)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
//vcount +65

	else if(loss_data1 % 10 == 7 && ((vcount<312 && vcount>304 && hcount == 414)|| (vcount == 305 && hcount > 409 && hcount < 415)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
	else if(loss_data2 % 10 == 7 && ((vcount<312 && vcount>304 && hcount == 454)|| (vcount == 305 && hcount > 449 && hcount < 455)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
	else if(loss_data3 % 10 == 7 && ((vcount<312 && vcount>304 && hcount == 494)|| (vcount == 305 && hcount > 489 && hcount < 495)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
	else if(loss_data4 % 10 == 7 && ((vcount<312 && vcount>304 && hcount == 534)|| (vcount == 305 && hcount > 529 && hcount < 535)))begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
	
	
// 8
	else if(read_data1 % 10 == 8 && ((vcount<247 && vcount>239 && (hcount == 414 || hcount ==410))||((vcount == 240|| vcount == 243 || vcount==246)&& hcount<415 && hcount > 409)))  begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
	else if(read_data2 % 10 == 8 && ((vcount<247 && vcount>239 && (hcount == 454 || hcount ==450))||((vcount == 240|| vcount == 243 || vcount==246)&& hcount<455 && hcount > 449)))  begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
	else if(read_data3 % 10 == 8 && ((vcount<247 && vcount>239 && (hcount == 494 || hcount ==490))||((vcount == 240|| vcount == 243 || vcount==246)&& hcount<495 && hcount > 489)))  begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
	else if(read_data4 % 10 == 8 && ((vcount<247 && vcount>239 && (hcount == 534 || hcount ==530))||((vcount == 240|| vcount == 243 || vcount==246)&& hcount<535 && hcount > 529)))  begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
	// vcount -65
	
	else if(wrote_data1 % 10 == 8 && ((vcount<182 && vcount>174 && (hcount == 414 || hcount ==410))||((vcount == 175|| vcount == 178 || vcount==181)&& hcount<415 && hcount > 409)))  begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
	else if(wrote_data2 % 10 == 8 && ((vcount<182 && vcount>174 && (hcount == 454 || hcount ==450))||((vcount == 175|| vcount == 178 || vcount==181)&& hcount<455 && hcount > 449)))  begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
	else if(wrote_data3 % 10 == 8 && ((vcount<182 && vcount>174 && (hcount == 494 || hcount ==490))||((vcount == 175|| vcount == 178 || vcount==181)&& hcount<495 && hcount > 489)))  begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
	else if(wrote_data4 % 10 == 8 && ((vcount<182 && vcount>174 && (hcount == 534 || hcount ==530))||((vcount == 175|| vcount == 178 || vcount==181)&& hcount<535 && hcount > 529)))  begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
	//vcount +65
	else if(loss_data1 % 10 == 8 && ((vcount<312 && vcount>304 && (hcount == 414 || hcount ==410))||((vcount == 305|| vcount == 308 || vcount==311)&& hcount<415 && hcount > 409)))  begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
	else if(loss_data2 % 10 == 8 && ((vcount<312 && vcount>304 && (hcount == 454 || hcount ==450))||((vcount == 305|| vcount == 308 || vcount==311)&& hcount<455 && hcount > 449)))  begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
	else if(loss_data3 % 10 == 8 && ((vcount<312 && vcount>304 && (hcount == 494 || hcount ==490))||((vcount == 305|| vcount == 308 || vcount==311)&& hcount<495 && hcount > 489)))  begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
	else if(loss_data4 % 10 == 8 && ((vcount<312 && vcount>304 && (hcount == 534 || hcount ==530))||((vcount == 305|| vcount == 308 || vcount==311)&& hcount<535 && hcount > 529)))  begin
		green <= 8'h00;
				blue <= 8'h00; 
				red <= 8'h00;
	end
	
// 9

	else if(read_data1 % 10 == 9 && ((hcount == 414 && vcount <247 && vcount > 239)||((vcount == 240|| vcount == 243 || vcount==246)&& hcount<415 && hcount > 409)||
	(hcount == 410 && vcount < 243 && vcount > 240)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	else if(read_data2 % 10 == 9 && ((hcount == 454 && vcount <247 && vcount > 239)||((vcount == 240|| vcount == 243 || vcount==246)&& hcount<455 && hcount > 449)||
	(hcount == 450 && vcount < 243 && vcount > 240)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	else if(read_data3 % 10 == 9 && ((hcount == 494 && vcount <247 && vcount > 239)||((vcount == 240|| vcount == 243 || vcount==246)&& hcount<495 && hcount > 489)||
	(hcount == 490 && vcount < 243 && vcount > 240)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	else if(read_data4 % 10 == 9 && ((hcount == 534 && vcount <247 && vcount > 239)||((vcount == 240|| vcount == 243 || vcount==246)&& hcount<535 && hcount > 529)||
	(hcount == 530 && vcount < 243 && vcount > 240)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
	//vcount -65
	
	else if(wrote_data1 % 10 == 9 && ((hcount == 414 && vcount <182 && vcount > 174)||((vcount == 175|| vcount == 178 || vcount==181)&& hcount<415 && hcount > 409)||
	(hcount == 410 && vcount < 178 && vcount > 175)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	else if(wrote_data2 % 10 == 9 && ((hcount == 454 && vcount <182 && vcount > 174)||((vcount == 175|| vcount == 178 || vcount==181)&& hcount<455 && hcount > 449)||
	(hcount == 450 && vcount < 178 && vcount > 175)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	else if(wrote_data3 % 10 == 9 && ((hcount == 494 && vcount <182 && vcount > 174)||((vcount == 175|| vcount == 178 || vcount==181)&& hcount<495 && hcount > 489)||
	(hcount == 490 && vcount < 178 && vcount > 175)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	else if(wrote_data4 % 10 == 9 && ((hcount == 534 && vcount <182 && vcount > 174)||((vcount == 175|| vcount == 178 || vcount==181)&& hcount<535 && hcount > 529)||
	(hcount == 530 && vcount < 178 && vcount > 175)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
	//wrote +65
	
	else if(loss_data1 % 10 == 9 && ((hcount == 414 && vcount <312 && vcount > 304)||((vcount == 305|| vcount == 308 || vcount==311)&& hcount<415 && hcount > 409)||
	(hcount == 410 && vcount < 308 && vcount > 305)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	else if(loss_data2 % 10 == 9 && ((hcount == 454 && vcount <312 && vcount > 304)||((vcount == 305|| vcount == 308 || vcount==311)&& hcount<455 && hcount > 449)||
	(hcount == 450 && vcount < 308 && vcount > 305)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	else if(loss_data3 % 10 == 9 && ((hcount == 494 && vcount <312 && vcount > 304)||((vcount == 305|| vcount == 308 || vcount==311)&& hcount<495 && hcount > 489)||
	(hcount == 490 && vcount < 308 && vcount > 305)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	else if(loss_data4 % 10 == 9 && ((hcount == 534 && vcount <312 && vcount > 304)||((vcount == 305|| vcount == 308 || vcount==311)&& hcount<535 && hcount > 529)||
	(hcount == 530 && vcount < 308 && vcount > 305)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
	//////////////////////////////// onlar basamagi ///////////////////////////////////////////
// 0	
	// 0	
	 else if((read_data1 /10) % 10 == 0 &&(((hcount == 400 || hcount== 404) && vcount < 247 && vcount >240) || ((vcount == 246 || vcount == 240) && hcount<404 && hcount > 400)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end

else if((read_data2 / 10)%10 == 0 && (((hcount == 440 || hcount== 444) && vcount < 247 && vcount >240) || ((vcount == 246 || vcount == 240) && hcount<444 && hcount > 440)))begin
    begin
        green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
    end
end

else if((read_data3 / 10)%10 == 0 && (((hcount == 480 || hcount== 484) && vcount < 247 && vcount >240) || ((vcount == 246 || vcount == 240) && hcount<484 && hcount > 480)))begin
    begin
        green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
    end
end

else if((read_data4 / 10)%10 == 0 && (((hcount == 520 || hcount== 524) && vcount < 247 && vcount >240) || ((vcount == 246 || vcount == 240) && hcount<524 && hcount > 520)))begin
    begin
        green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
    end
end


// -65 vcount starts

else if((wrote_data1 / 10)%10 == 0 && (((hcount == 400 || hcount== 404) && vcount < 182 && vcount >175) || ((vcount == 181 || vcount == 175) && hcount<404 && hcount > 400)))
begin 
        green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
end

else if((wrote_data2 / 10)%10 == 0 && (((hcount == 440 || hcount== 444) && vcount < 182 && vcount >175) || ((vcount == 181 || vcount == 175) && hcount<444 && hcount > 440)))
begin
        green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
end

else if((wrote_data3 / 10)%10 == 0 && (((hcount == 480 ||  hcount== 484) && vcount < 182 && vcount >175) || ((vcount == 181 || vcount == 175) && hcount<484 && hcount > 480)))
begin
        green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
end

else if((wrote_data4 / 10)%10 == 0 && (((hcount == 520 || hcount== 524) && vcount < 182 && vcount >175) || ((vcount == 181 || vcount == 175) && hcount<524 && hcount > 520)))
begin
        green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
end

// +65 vcount starts

else if((loss_data1 / 10)%10 == 0 && (((hcount == 400 || hcount== 404) && vcount < 312	 && vcount >305) || ((vcount == 311 || vcount == 305) && hcount<404 && hcount > 400)))
begin
        green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
end


else if((loss_data2 / 10)%10 == 0 && (((hcount == 440 || hcount== 444) && vcount < 312 && vcount >305) || ((vcount == 311 || vcount == 305) && hcount<444 && hcount > 440)))
begin
       green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
end


else if((loss_data3 / 10)%10 == 0 && (((hcount == 480 ||  hcount== 484) && vcount < 312 && vcount >305) || ((vcount == 311 || vcount == 305) && hcount<484 && hcount > 480) ))
begin
       green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
end


else if((loss_data4 / 10)%10 == 0 && (((hcount == 520 ||  hcount== 524) && vcount < 312 && vcount >305) || ((vcount == 311 || vcount == 305) && hcount<524 && hcount > 520) ))
begin
        green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
end
 // 1

	// vcount starts

else if((read_data1 / 10)%10 == 1 &&(vcount<247 && vcount>239 && hcount == 404))
begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
end

else if((read_data2 / 10) %10== 1 &&(vcount<247 && vcount>239 && hcount == 444))
begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
end

else if((read_data3 / 10)%10 == 1 &&(vcount<247 && vcount>239 && hcount == 484))
begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
end

else if((read_data4 / 10)%10 == 1 &&(vcount<247 && vcount>239 && hcount == 524))
begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
end


// vcount -65 starts

else if((wrote_data1 / 10)%10 == 1 &&(vcount<182 && vcount>174 && hcount == 404))
begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
end

else if((wrote_data2 / 10)%10 == 1 &&(vcount<182 && vcount>174 && hcount == 444))
begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
end

else if((wrote_data3 / 10)%10 == 1 &&(vcount<182 && vcount>174 && hcount == 484))
begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
end

else if((wrote_data4 / 10)%10 == 1 &&(vcount<182 && vcount>174 && hcount == 524))
begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
end


// vcount +65 starts

else if((loss_data1 / 10)%10 == 1 &&(vcount<312 && vcount>304 && hcount == 404))
begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
end

else if((loss_data2 / 10) %10 == 1 &&(vcount<312 && vcount>304 && hcount == 444))
begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
end


else if((loss_data3 / 10)%10 == 1 &&(vcount<312 && vcount>304 && hcount == 484))
begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
end


else if((loss_data4 / 10) %10 == 1 &&(vcount<312 && vcount>304 && hcount == 524))
begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
end
	// 2
	else if((read_data1 / 10)%10 == 2 &&(((vcount==240 || vcount==243 || vcount == 246)&& hcount>399 && hcount<405) || ((vcount == 242 || vcount == 241)&& hcount == 404) || ((vcount == 244 || vcount == 245)&& hcount == 400)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	// vcount starts 

else if((read_data1 / 10)%10 == 2 &&(((vcount==240 || vcount==243 || vcount == 246)&& hcount>399 && hcount<405) || ((vcount == 242 || vcount == 241)&& hcount == 404) || ((vcount == 244 || vcount == 245)&& hcount == 400)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
else if((read_data2 / 10)%10 == 2 &&(((vcount==240 || vcount==243 || vcount == 246)&& hcount>439 && hcount<445) || ((vcount == 242 || vcount == 241)&& hcount == 444) || ((vcount == 244 || vcount == 245)&& hcount == 440)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
else if((read_data3 / 10)%10 == 2 &&(((vcount==240 || vcount==243 || vcount == 246)&& hcount>479 && hcount<485) || ((vcount == 242 || vcount == 241)&& hcount == 484) || ((vcount == 244 || vcount == 245)&& hcount == 480)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
else if((read_data4 / 10)%10 == 2 &&(((vcount==240 || vcount==243 || vcount == 246)&& hcount>519 && hcount<525) || ((vcount == 242 || vcount == 241)&& hcount == 524) || ((vcount == 244 || vcount == 245)&& hcount == 520)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
	
// vcount -65

else if((wrote_data1 / 10)%10 == 2 &&(((vcount==175 || vcount==178 || vcount == 181)&& hcount>399 && hcount<405) || ((vcount == 177 || vcount == 176)&& hcount == 404) || ((vcount == 179 || vcount == 180)&& hcount == 400)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
else if((wrote_data2 / 10)%10 == 2 &&(((vcount==175 || vcount==178 || vcount == 181)&& hcount>439 && hcount<445) || ((vcount == 177 || vcount == 176)&& hcount == 444) || ((vcount == 179 || vcount == 180)&& hcount == 440)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
else if((wrote_data3 / 10) %10== 2 &&(((vcount==175 || vcount==178 || vcount == 181)&& hcount>479 && hcount<485) || ((vcount == 177 || vcount == 176)&& hcount == 484) || ((vcount == 179 || vcount == 180)&& hcount == 480)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
else if((wrote_data4 / 10)%10 == 2 &&(((vcount==175 || vcount==178 || vcount == 181)&& hcount>519 && hcount<525) || ((vcount == 177 || vcount == 176)&& hcount == 524) || ((vcount == 179 || vcount == 180)&& hcount == 520)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
	
// vcount +65
	
else if((loss_data1 / 10) %10== 2 &&(((vcount==305 || vcount==308 || vcount == 311)&& hcount>399 && hcount<405) || ((vcount == 307 || vcount == 306)&& hcount == 404) || ((vcount == 309 || vcount == 310)&& hcount == 400)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
else if((loss_data2 / 10)%10 == 2 &&(((vcount==305 || vcount==308 || vcount == 311)&& hcount>439 && hcount<445) || ((vcount == 307 || vcount == 306)&& hcount == 444) || ((vcount == 309 || vcount == 310)&& hcount == 440)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
else if((loss_data3 / 10)%10 == 2 &&(((vcount==305 || vcount==308 || vcount == 311)&& hcount>479 && hcount<485) || ((vcount == 307 || vcount == 306)&& hcount == 484) || ((vcount == 309 || vcount == 310)&& hcount == 480)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
else if((loss_data4 / 10)%10 == 2 &&(((vcount==305 || vcount==308 || vcount == 311)&& hcount>519 && hcount<525) || ((vcount == 307 || vcount == 306)&& hcount == 524) || ((vcount == 309 || vcount == 310)&& hcount == 520)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end

// 3

// vcount starts

else if((read_data1 / 10)%10 == 3 &&((hcount == 404 && vcount <247 && vcount > 239)||((vcount == 240|| vcount == 243 || vcount==246)&& hcount<405 && hcount > 399)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
	else if((read_data2 / 10)%10 == 3 &&((hcount == 444 && vcount <247 && vcount > 239)||((vcount == 240|| vcount == 243 || vcount==246)&& hcount<445 && hcount > 439)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
	else if((read_data3 / 10)%10 == 3 &&((hcount == 484 && vcount <247 && vcount > 239)||((vcount == 240|| vcount == 243 || vcount==246)&& hcount<485 && hcount > 479)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
	else if((read_data4 / 10)%10 == 3 &&((hcount == 524 && vcount <247 && vcount > 239)||((vcount == 240|| vcount == 243 || vcount==246)&& hcount<525 && hcount > 519)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
// vcount -65
	
else if((wrote_data1 / 10)%10 == 3 &&((hcount == 404 && vcount <182 && vcount > 174)||((vcount == 175|| vcount == 178 || vcount==181)&& hcount<405 && hcount > 399)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
	else if((wrote_data2 / 10)%10 == 3 &&((hcount == 444 && vcount <182 && vcount > 174)||((vcount == 175|| vcount == 178 || vcount==181)&& hcount<445 && hcount > 439)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
	else if((wrote_data3 / 10)%10 == 3 &&((hcount == 484 && vcount <182 && vcount > 174)||((vcount == 175|| vcount == 178 || vcount==181)&& hcount<485 && hcount > 479)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
	else if((wrote_data4 / 10)%10 == 3 &&((hcount == 524 && vcount <182 && vcount > 174)||((vcount == 175|| vcount == 178 || vcount==181)&& hcount<525 && hcount > 519)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end

// vcount +65

else if((loss_data1 / 10)%10 == 3 &&((hcount == 404 && vcount <312 && vcount > 304)||((vcount == 305|| vcount == 308 || vcount==311)&& hcount<405 && hcount > 399)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
	else if((loss_data2 / 10)%10 == 3 &&((hcount == 444 && vcount <312 && vcount > 304)||((vcount == 305|| vcount == 308 || vcount==311)&& hcount<445 && hcount > 439)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
	else if((loss_data3 / 10)%10 == 3 &&((hcount == 484 && vcount <312 && vcount > 304)||((vcount == 305|| vcount == 308 || vcount==311)&& hcount<485 && hcount > 479)))begin
	green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
	else if((loss_data4 / 10)%10 == 3 &&((hcount == 524 && vcount <312 && vcount > 304)||((vcount == 305|| vcount == 308 || vcount==311)&& hcount<525 && hcount > 519)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
// 4

	// vcount starts

else if((read_data1 / 10)%10 == 4 &&((vcount<247&& vcount>239&& hcount == 404)||(vcount == 243&& hcount > 399 && hcount < 405)||(hcount==400&& vcount>239&& vcount<244)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
	else if((read_data2 / 10)%10 == 4 &&((vcount<247&& vcount>239&& hcount == 444)||(vcount == 243&& hcount > 439 && hcount < 445)||(hcount==440&& vcount>239&& vcount<244)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
	else if((read_data3 / 10)%10 == 4 &&((vcount<247&& vcount>239&& hcount == 484)||(vcount == 243&& hcount > 479 && hcount < 485)||(hcount==480&& vcount>239&& vcount<244)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
	
	else if((read_data4 / 10)%10 == 4 &&((vcount<247&& vcount>239&& hcount == 524)||(vcount == 243&& hcount > 519 && hcount < 525)||(hcount==520&& vcount>239&& vcount<244)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
// vcount -65

else if((wrote_data1 / 10)%10 == 4 &&((vcount<182&& vcount>174&& hcount == 404)||(vcount == 178&& hcount > 399 && hcount < 405)||(hcount==400&& vcount>174&& vcount<179)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
	else if((wrote_data2 / 10)%10 == 4 &&((vcount<182&& vcount>174&& hcount == 444)||(vcount == 178&& hcount > 439 && hcount < 445)||(hcount==440&& vcount>174&& vcount<179)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
	else if((wrote_data3 / 10)%10 == 4 &&((vcount<182&& vcount>174&& hcount == 484)||(vcount == 178&& hcount > 479 && hcount < 485)||(hcount==480&& vcount>174&& vcount<179)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
	
	else if((wrote_data4 / 10)%10 == 4 &&((vcount<182&& vcount>174&& hcount == 524)||(vcount == 178&& hcount > 519 && hcount < 525)||(hcount==520&& vcount>174&& vcount<179)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
// vcount +65

else if((loss_data1 / 10)%10 == 4 &&((vcount<312&& vcount>304&& hcount == 404)||(vcount == 308&& hcount > 399 && hcount < 415)||(hcount==400&& vcount>304&& vcount<309)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
	else if((loss_data2 / 10)%10 == 4 &&((vcount<312&& vcount>304&& hcount == 444)||(vcount == 308&& hcount > 439 && hcount < 445)||(hcount==440&& vcount>304&& vcount<309)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
	else if((loss_data3 / 10)%10 == 4 &&((vcount<312&& vcount>304&& hcount == 484)||(vcount == 308&& hcount > 479 && hcount < 485)||(hcount==480&& vcount>304&& vcount<309)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
	
	else if((loss_data4 / 10)%10 == 4 &&((vcount<312&& vcount>304&& hcount == 524)||(vcount == 308&& hcount > 519 && hcount < 525)||(hcount==520&& vcount>304&& vcount<309)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
// 5

	// vcount starts

else if((read_data1 / 10)%10 == 5 && (((vcount==240 || vcount==243 || vcount == 246)&& hcount>399 && hcount<405) || (hcount == 404 && vcount < 243 && vcount > 240) || (hcount == 400 && vcount < 246 && vcount > 243)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
	else if((read_data2 / 10)%10 == 5 && (((vcount==240 || vcount==243 || vcount == 246)&& hcount>439 && hcount<445) || (hcount == 444 && vcount < 243 && vcount > 240) || (hcount == 440 && vcount < 246 && vcount > 243)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
	else if((read_data3 / 10)%10 == 5 && (((vcount==240 || vcount==243 || vcount == 246)&& hcount>489 && hcount<495) || (hcount == 484 && vcount < 243 && vcount > 240) || (hcount == 480 && vcount < 246 && vcount > 243)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
	else if((read_data4 / 10)%10 == 5 && (((vcount==240 || vcount==243 || vcount == 246)&& hcount>519 && hcount<525) || (hcount == 524 && vcount < 243 && vcount > 240) || (hcount == 520 && vcount < 246 && vcount > 243)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
// vcount -65
	
	else if((wrote_data1 / 10)%10 == 5 && (((vcount==175 || vcount==178 || vcount == 181)&& hcount>399 && hcount<405) || (hcount == 404 && vcount < 178 && vcount > 175) || (hcount == 400 && vcount < 181 && vcount > 178)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
	else if((wrote_data2 / 10)%10 == 5 && (((vcount==175 || vcount==178 || vcount == 181)&& hcount>439 && hcount<445) || (hcount == 444 && vcount < 178 && vcount > 175) || (hcount == 440 && vcount < 181 && vcount > 178)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
	else if((wrote_data3 / 10)%10 == 5 && (((vcount==175 || vcount==178 || vcount == 181)&& hcount>479 && hcount<485) || (hcount == 484 && vcount < 178 && vcount > 175) || (hcount == 480 && vcount < 181 && vcount > 178)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
	else if((wrote_data4 / 10)%10 == 5 && (((vcount==175 || vcount==178 || vcount == 181)&& hcount>519 && hcount<525) || (hcount == 524 && vcount < 178 && vcount > 175) || (hcount == 520 && vcount < 181 && vcount > 178)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
// vcount +65
	
	else if((loss_data1 / 10)%10 == 5 && (((vcount==305 || vcount==308 || vcount == 311)&& hcount>399 && hcount<405) || (hcount == 404 && vcount < 308 && vcount > 305) || (hcount == 400 && vcount < 311 && vcount > 308)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
	else if((loss_data2 / 10)%10 == 5 && (((vcount==305 || vcount==308 || vcount == 311)&& hcount>439 && hcount<445) || (hcount == 444 && vcount < 308 && vcount > 305) || (hcount == 440 && vcount < 311 && vcount > 308)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
	else if((loss_data3 / 10)%10 == 5 && (((vcount==305 || vcount==308 || vcount == 311)&& hcount>479 && hcount<485) || (hcount == 484 && vcount < 308 && vcount > 305) || (hcount == 480 && vcount < 311 && vcount > 308)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
	else if((loss_data4 / 10)%10 == 5 && (((vcount==305 || vcount==308 || vcount == 311)&& hcount>519 && hcount<525) || (hcount == 524 && vcount < 308 && vcount > 305) || (hcount == 520 && vcount < 311 && vcount > 308)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end

	
// 6

	else if((read_data1)/10 % 10 == 6 && (((vcount==240 || vcount==243 || vcount == 246)&& hcount>399 && hcount<405) || (vcount<247 && vcount>239 && hcount == 404) || (hcount == 400 && vcount < 246 && vcount > 243)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
	else if((read_data2)/10 % 10 == 6 && (((vcount==240 || vcount==243 || vcount == 246)&& hcount>439 && hcount<445) || (vcount<247 && vcount>239 && hcount == 444) || (hcount == 440 && vcount < 246 && vcount > 243)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
	else if((read_data3)/10 % 10 == 6 && (((vcount==240 || vcount==243 || vcount == 246)&& hcount>479 && hcount<485) || (vcount<247 && vcount>239 && hcount == 484) || (hcount == 480 && vcount < 246 && vcount > 243)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
	else if((read_data4)/10 % 10 == 6 && (((vcount==240 || vcount==243 || vcount == 246)&& hcount>519 && hcount<525) || (vcount<247 && vcount>239 && hcount == 524) || (hcount == 520 && vcount < 246 && vcount > 243)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
	//vcount -65
	
	else if((wrote_data1)/10 % 10 == 6 && (((vcount==175 || vcount==178 || vcount == 181)&& hcount>399 && hcount<405) || (vcount<182 && vcount>174 && hcount == 404) || (hcount == 400 && vcount < 181 && vcount > 178)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
else 	if((wrote_data2)/10 % 10 == 6 && (((vcount==175 || vcount==178 || vcount == 181)&& hcount>439 && hcount<445) || (vcount<182 && vcount>174 && hcount == 444) || (hcount == 440 && vcount < 181 && vcount > 178)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
else 	if((wrote_data3)/10 % 10 == 6 && (((vcount==175 || vcount==178 || vcount == 181)&& hcount>479 && hcount<485) || (vcount<182 && vcount>174 && hcount == 484) || (hcount == 480 && vcount < 181 && vcount > 178)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
	else if((wrote_data4)/10 % 10 == 6 && (((vcount==175 || vcount==178 || vcount == 181)&& hcount>519 && hcount<525) || (vcount<182 && vcount>174 && hcount == 524) || (hcount == 520 && vcount < 181 && vcount > 178)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
	// count +65
	
else 	if((loss_data1)/10 % 10 == 6 && (((vcount==305 || vcount==308 || vcount == 311)&& hcount>399 && hcount<405) || (vcount<312 && vcount>304 && hcount == 404) || (hcount == 400 && vcount < 311 && vcount > 308)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
else 	if((loss_data2)/10 % 10 == 6 && (((vcount==305 || vcount==308 || vcount == 311)&& hcount>439 && hcount<445) || (vcount<312 && vcount>304 && hcount == 444) || (hcount == 440 && vcount < 311 && vcount > 308)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
	else if((loss_data3)/10 % 10 == 6 && (((vcount==305 || vcount==308 || vcount == 311)&& hcount>479 && hcount<485) || (vcount<312 && vcount>304 && hcount == 484) || (hcount == 480 && vcount < 311 && vcount > 308)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
	else if((loss_data4)/10 % 10 == 6 && (((vcount==305 || vcount==308 || vcount == 311)&& hcount>519 && hcount<525) || (vcount<312 && vcount>304 && hcount == 524) || (hcount == 520 && vcount < 311 && vcount > 308)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
// 7
	else if((read_data1 % 10)/10  == 7 && ((vcount<247 && vcount>239 && hcount == 404)|| (vcount == 240 && hcount > 399 && hcount < 405)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	else if((read_data1)/10 % 10 == 7 && ((vcount<247 && vcount>239 && hcount == 404)|| (vcount == 240 && hcount > 399 && hcount < 405)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
	else if((read_data2)/10 % 10 == 7 && ((vcount<247 && vcount>239 && hcount == 444)|| (vcount == 240 && hcount > 439 && hcount < 445)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
	else if((read_data3)/10 % 10 == 7 && ((vcount<247 && vcount>239 && hcount == 484)|| (vcount == 240 && hcount > 479 && hcount < 485)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
	else if((read_data4)/10 % 10 == 7 && ((vcount<247 && vcount>239 && hcount == 524)|| (vcount == 240 && hcount > 529 && hcount < 525)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
	
	//vcount -65
	
	else if((wrote_data1)/10 % 10 == 7 && ((vcount<182 && vcount>174 && hcount == 404)|| (vcount == 175 && hcount > 399 && hcount < 405)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
	else if((wrote_data2)/10 % 10 == 7 && ((vcount<182 && vcount>174 && hcount == 444)|| (vcount == 175 && hcount > 439 && hcount < 445)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
	else if((wrote_data3)/10 % 10 == 7 && ((vcount<182 && vcount>174 && hcount == 484)|| (vcount == 175 && hcount > 479 && hcount < 455)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
	else if((wrote_data4)/10 % 10 == 7 && ((vcount<182 && vcount>174 && hcount == 524)|| (vcount == 175 && hcount > 519 && hcount < 525)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
//vcount +65

	else if((loss_data1)/10 % 10 == 7 && ((vcount<312 && vcount>304 && hcount == 404)|| (vcount == 305 && hcount > 399 && hcount < 405)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
	else if((loss_data2)/10 % 10 == 7 && ((vcount<312 && vcount>304 && hcount == 444)|| (vcount == 305 && hcount > 439 && hcount < 445)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
	else if((loss_data3)/10 % 10 == 7 && ((vcount<312 && vcount>304 && hcount == 484)|| (vcount == 305 && hcount > 479 && hcount < 485)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
	else if((loss_data4)/10 % 10 == 7 && ((vcount<312 && vcount>304 && hcount == 524)|| (vcount == 305 && hcount > 519 && hcount < 425)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
// 8

	else if((read_data1)/10 % 10 == 8 && ((vcount<247 && vcount>239 && (hcount == 404 || hcount ==400))||((vcount == 240|| vcount == 243 || vcount==246)&& hcount<405 && hcount > 399)))  begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
	else if((read_data2)/10 % 10 == 8 && ((vcount<247 && vcount>239 && (hcount == 444 || hcount ==440))||((vcount == 240|| vcount == 243 || vcount==246)&& hcount<445 && hcount > 439)))  begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
else 	if((read_data3)/10 % 10 == 8 && ((vcount<247 && vcount>239 && (hcount == 484 || hcount ==480))||((vcount == 240|| vcount == 243 || vcount==246)&& hcount<485 && hcount > 479)))  begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
	else if((read_data4)/10 % 10 == 8 && ((vcount<247 && vcount>239 && (hcount == 524 || hcount ==520))||((vcount == 240|| vcount == 243 || vcount==246)&& hcount<525 && hcount > 519)))  begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
	// vcount -65
	
	else if((wrote_data1)/10 % 10 == 8 && ((vcount<182 && vcount>174 && (hcount == 404 || hcount ==400))||((vcount == 175|| vcount == 178 || vcount==181)&& hcount<405 && hcount > 399)))  begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
else 	if((wrote_data2)/10 % 10 == 8 && ((vcount<182 && vcount>174 && (hcount == 444 || hcount ==440))||((vcount == 175|| vcount == 178 || vcount==181)&& hcount<445 && hcount > 439)))  begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
	else if((wrote_data3)/10 % 10 == 8 && ((vcount<182 && vcount>174 && (hcount == 484 || hcount ==480))||((vcount == 175|| vcount == 178 || vcount==181)&& hcount<485 && hcount > 479)))  begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
	else if((wrote_data4)/10 % 10 == 8 && ((vcount<182 && vcount>174 && (hcount == 524 || hcount ==520))||((vcount == 175|| vcount == 178 || vcount==181)&& hcount<525 && hcount > 519)))  begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
	//vcount +65
	else if((loss_data1)/10 % 10 == 8 && ((vcount<312 && vcount>304 && (hcount == 404 || hcount ==400))||((vcount == 305|| vcount == 308 || vcount==311)&& hcount<405 && hcount > 399)))  begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
	else if((loss_data2)/10 % 10 == 8 && ((vcount<312 && vcount>304 && (hcount == 444 || hcount ==440))||((vcount == 305|| vcount == 308 || vcount==311)&& hcount<445 && hcount > 439)))  begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
else 	if((loss_data3)/10 % 10 == 8 && ((vcount<312 && vcount>304 && (hcount == 484 || hcount ==480))||((vcount == 305|| vcount == 308 || vcount==311)&& hcount<485 && hcount > 479)))  begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
	else if((loss_data4)/10 % 10 == 8 && ((vcount<312 && vcount>304 && (hcount == 524 || hcount ==520))||((vcount == 305|| vcount == 308 || vcount==311)&& hcount<525 && hcount > 519)))  begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
// 9

else 	if((read_data1)/10 % 10 == 9 && ((hcount == 404 && vcount <247 && vcount > 239)||((vcount == 240|| vcount == 243 || vcount==246)&& hcount<405 && hcount > 399)||
	(hcount == 400 && vcount < 246 && vcount > 243)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
else 	if((read_data2)/10 % 10 == 9 && ((hcount == 444 && vcount <247 && vcount > 239)||((vcount == 240|| vcount == 243 || vcount==246)&& hcount<445 && hcount > 439)||
	(hcount == 440 && vcount < 246 && vcount > 243)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	else if((read_data3)/10 % 10 == 9 && ((hcount == 454 && vcount <247 && vcount > 239)||((vcount == 240|| vcount == 243 || vcount==246)&& hcount<485 && hcount > 479)||
	(hcount == 480 && vcount < 246 && vcount > 243)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
else 	if((read_data4)/10 % 10 == 9 && ((hcount == 524 && vcount <247 && vcount > 239)||((vcount == 240|| vcount == 243 || vcount==246)&& hcount<525 && hcount > 519)||
	(hcount == 520 && vcount < 246 && vcount > 243)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
	//vcount -65
	
else 	if((wrote_data1)/10 % 10 == 9 && ((hcount == 404 && vcount <182 && vcount > 174)||((vcount == 175|| vcount == 178 || vcount==181)&& hcount<405 && hcount > 399)||
	(hcount == 400 && vcount < 181 && vcount > 178)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	else if((wrote_data2)/10 % 10 == 9 && ((hcount == 444 && vcount <182 && vcount > 174)||((vcount == 175|| vcount == 178 || vcount==181)&& hcount<445 && hcount > 439)||
	(hcount == 440 && vcount < 181 && vcount > 178)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	else if((wrote_data3)/10 % 10 == 9 && ((hcount == 484 && vcount <182 && vcount > 174)||((vcount == 175|| vcount == 178 || vcount==181)&& hcount<485 && hcount > 479)||
	(hcount == 480 && vcount < 181 && vcount > 178)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
else 	if((wrote_data4)/10 % 10 == 9 && ((hcount == 524 && vcount <182 && vcount > 174)||((vcount == 175|| vcount == 178 || vcount==181)&& hcount<525 && hcount > 519)||
	(hcount == 520 && vcount < 181 && vcount > 178)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	
	//wrote +65
	
else 	if((loss_data1)/10 % 10 == 9 && ((hcount == 404 && vcount <312 && vcount > 304)||((vcount == 305|| vcount == 308 || vcount==311)&& hcount<405 && hcount > 399)||
	(hcount == 400 && vcount < 311 && vcount > 308)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	else if((loss_data2)/10 % 10 == 9 && ((hcount == 444 && vcount <312 && vcount > 304)||((vcount == 305|| vcount == 308 || vcount==311)&& hcount<445 && hcount > 439)||
	(hcount == 440 && vcount < 311 && vcount > 308)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
	else if((loss_data3)/10 % 10 == 9 && ((hcount == 484 && vcount <312 && vcount > 304)||((vcount == 305|| vcount == 308 || vcount==311)&& hcount<485 && hcount > 479)||
	(hcount == 480 && vcount < 311 && vcount > 308)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
else 	if((loss_data4)/10 % 10 == 9 && ((hcount == 524 && vcount <312 && vcount > 304)||((vcount == 305|| vcount == 308 || vcount==311)&& hcount<525 && hcount > 519)||
	(hcount == 520 && vcount < 311 && vcount > 308)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end 
	
	//////////////////////////////// yuzler basamagi ///////////////////////////////////////////
// 0	
	 else if((read_data1 /100) % 10 == 0 &&(((hcount == 390 || hcount== 394) && vcount < 247 && vcount >240) || ((vcount == 246 || vcount == 240) && hcount<394 && hcount > 390)))begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	end
else 	if((read_data2 /100) % 10 == 0 && (((hcount == 430 || hcount== 434) && vcount < 247 && vcount >240) || ((vcount == 246 || vcount == 240) && hcount<434 && hcount > 430)))begin
    
      green <= 8'h00;
      blue <= 8'h00;
      red <= 8'h00;
    end
	

	else if((read_data3/100) % 10 == 0 && (((hcount == 470 || hcount== 474) && vcount < 247 && vcount >240) || ((vcount == 246 || vcount == 240) && hcount<474 && hcount > 470)))begin
    
      green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
    
	end

else 	if((read_data4/100) % 10 == 0 && (((hcount == 510 || hcount== 514) && vcount < 247 && vcount >240) || ((vcount == 246 || vcount == 240) && hcount<514 && hcount > 510)))begin
    
      green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
    
	end
	// -65 vcount starts

else if((wrote_data1/100) % 10 == 0 && (((hcount == 390 || hcount== 394) && vcount < 182 && vcount >175) || ((vcount == 181 || vcount == 175) && hcount<394 && hcount > 390)))
begin 
        green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
end

else if((wrote_data2/100) % 10 == 0 && (((hcount == 430 || hcount== 434) && vcount < 182 && vcount >175) || ((vcount == 181 || vcount == 175) && hcount<434 && hcount > 430)))
begin
        green <= 8'h00;
      blue <= 8'h00;
      red <= 8'h00;
end

else if((wrote_data3/100) % 10 == 0 && (((hcount == 470 || hcount== 474) && vcount < 182 && vcount >175) || ((vcount == 181 || vcount == 175) && hcount<474 && hcount > 470)))
begin
        green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
end

else if((wrote_data4/100) % 10 == 0 && (((hcount == 510 || hcount== 514) && vcount < 182 && vcount >175) || ((vcount == 181 || vcount == 175) && hcount<514 && hcount > 510)))
begin
        green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
end

// +65 vcount starts

else if((loss_data1/100) % 10 == 0 && (((hcount == 390 || hcount== 394) && vcount < 312	 && vcount >305) || ((vcount == 311 || vcount == 305) && hcount<394 && hcount > 390)))
begin
        green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
end


else if((loss_data2/100) % 10 == 0 && (((hcount == 430 || hcount== 434) && vcount < 312 && vcount >305) || ((vcount == 311 || vcount == 305) && hcount<434 && hcount > 430)))
begin
        green <= 8'h00;
      blue <= 8'h00;
      red <= 8'h00;
end


else if((loss_data3/100) % 10 == 0 && (((hcount == 470 || hcount== 474) && vcount < 312 && vcount >305) || ((vcount == 311 || vcount == 305) && hcount<474 && hcount > 470) ))
begin
        green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
end


else if((loss_data4/100) % 10 == 0 && (((hcount == 510 || hcount== 514) && vcount < 312 && vcount >305) || ((vcount == 311 || vcount == 305) && hcount<514 && hcount > 510) ))
begin
        green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
end
	
 // 1
else if((read_data1/100) % 10 == 1 &&(vcount<247 && vcount>239 && hcount == 394))begin
		
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
end
else if((read_data2/100) % 10 == 1 &&(vcount<247 && vcount>239 && hcount == 434))
begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
end

else if((read_data3/100) % 10 == 1 &&(vcount<247 && vcount>239 && hcount == 474))
begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
end

else if((read_data4/100) % 10 == 1 &&(vcount<247 && vcount>239 && hcount == 514))
begin
		green <= 8'h00;
      blue <= 8'h000; 
      red <= 8'h00;
end


// vcount -65 starts

else if((wrote_data1/100) % 10 == 1 &&(vcount<182 && vcount>174 && hcount == 394))
begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
end

else if((wrote_data2/100) % 10 == 1 &&(vcount<182 && vcount>174 && hcount == 434))
begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
end

else if((wrote_data3/100) % 10 == 1 &&(vcount<182 && vcount>174 && hcount == 474))
begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
end

else if((wrote_data4/100) % 10 == 1 &&(vcount<182 && vcount>174 && hcount == 514))
begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
end


// vcount +65 starts

else if((loss_data1/100) % 10 == 1 &&(vcount<312 && vcount>304 && hcount == 394))
begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
end

else if((loss_data2/100) % 10 == 1 &&(vcount<312 && vcount>304 && hcount == 434))
begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
end


else if((loss_data3/100) % 10 == 1 &&(vcount<312 && vcount>304 && hcount == 474))
begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
end


else if((loss_data4/100) % 10 == 1 &&(vcount<312 && vcount>304 && hcount == 514))
begin
		green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
end 
		else begin
			green <= 8'hff;
			blue <= 8'hff; 
			red <= 8'hff;
		end
	end
	 else if(vcount < 480 && vcount > 0 && hcount > 0 && hcount < 640)
	 begin
	 	 	green <= 8'hff;
      blue <= 8'hff; 
      red <= 8'hff;
	 end
	 else begin
	 	green <= 8'h00;
      blue <= 8'h00; 
      red <= 8'h00;
	 end
	 hcount = new_hcount+120;
			
			////////////////////////////////////////////////////////////////////////////////////// END SECTION 7
		end  // always
		
						
	// end pattern generate

	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// color output assignments
	// only output the colors if the counters are within the adressable video time constraints
	assign o_red = (new_hcount > 144 && new_hcount <= 783 && vcount > 35 && vcount <= 514) ? red : 8'h00;
	assign o_blue = (new_hcount > 144 && new_hcount <= 783 && vcount > 35 && vcount <= 514) ? blue : 8'h00;
	assign o_green = (new_hcount > 144 && new_hcount <= 783 && vcount > 35 && vcount <= 514) ? green : 8'h00;
	// end color output assignments
	
endmodule  // VGA_image_gen