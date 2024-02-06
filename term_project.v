module term_project(start, one, zero, outputdata,clock,r1,r4,w1,w4,c,int1,int2,w,int3,t);

input  start, one, zero, clock;
output reg [3:0] outputdata,t,int1,int2,int3=0;
output integer r1,r4,w1,w4;
output reg w,c;
reg [17:0] Buffer1, Buffer2, Buffer3, Buffer4;
reg [3:0] temp;
reg control =0, write=0;
integer i =0,counter1=0,counter2=0,counter3=0,counter4=0;
integer wrote_data1 =0,wrote_data2 =0,wrote_data3 =0,wrote_data4 =0,loss_data1=0,loss_data2=0,loss_data3=0,loss_data4=0;
integer read_data1=0,read_data2=0,read_data3=0,read_data4=0,deleted_data1=0,deleted_data2=0,deleted_data3=0,deleted_data4=0;

always @(posedge (one|| zero || start))begin

	if(read_data1-deleted_data1>0)begin // delete operation
		Buffer1[3*(counter1)-3]=0; 
		Buffer1[3*(counter1)-2]=0;
		Buffer1[3*(counter1)-1]=0;
		deleted_data1 = deleted_data1 +1;
	end
	if(read_data1-deleted_data1>0)begin // delete operation
		Buffer1[3*(counter1-1)-3]=0;
		Buffer1[3*(counter1-1)-2]=0;
		Buffer1[3*(counter1-1)-1]=0;
		deleted_data1 = deleted_data1 +1;	
	end
	if(read_data1-deleted_data1>0)begin // delete operation
		Buffer1[3*(counter1-2)-3]=0;
		Buffer1[3*(counter1-2)-2]=0;
		Buffer1[3*(counter1-2)-1]=0;
		deleted_data1 = deleted_data1 +1;	
	end
	if(read_data1-deleted_data1>0)begin // delete operation
		Buffer1[3*(counter1-3)-3]=0;
		Buffer1[3*(counter1-3)-2]=0;
		Buffer1[3*(counter1-3)-1]=0;
		deleted_data1 = deleted_data1 +1;	
	end
	if(read_data1-deleted_data1>0)begin // delete operation
		Buffer1[3*(counter1-4)-3]=0;
		Buffer1[3*(counter1-4)-2]=0;
		Buffer1[3*(counter1-4)-1]=0;
		deleted_data1 = deleted_data1 +1;	
	end
	if(read_data1-deleted_data1>0)begin // delete operation
		Buffer1[3*(counter1-5)-3]=0;
		Buffer1[3*(counter1-5)-2]=0;
		Buffer1[3*(counter1-5)-1]=0;
		deleted_data1 = deleted_data1 +1;	
	end
	if(read_data2-deleted_data2>0)begin // delete operation
		Buffer2[3*(counter2)-3]=0;
		Buffer2[3*(counter2)-2]=0;
		Buffer2[3*(counter2)-1]=0;
		deleted_data2 = deleted_data2 +1;	
	end
	if(read_data2-deleted_data2>0)begin // delete operation
		Buffer2[3*(counter2-1)-3]=0;
		Buffer2[3*(counter2-1)-2]=0;
		Buffer2[3*(counter2-1)-1]=0;
		deleted_data2 = deleted_data2 +1;	
	end
	if(read_data2-deleted_data2>0)begin // delete operation
		Buffer2[3*(counter2-2)-3]=0;
		Buffer2[3*(counter2-2)-2]=0;
		Buffer2[3*(counter2-2)-1]=0;
		deleted_data2 = deleted_data2 +1;	
	end
	if(read_data2-deleted_data2>0)begin // delete operation
		Buffer2[3*(counter2-3)-3]=0;
		Buffer2[3*(counter2-3)-2]=0;
		Buffer2[3*(counter2-3)-1]=0;
		deleted_data2 = deleted_data2 +1;	
	end
	if(read_data2-deleted_data2>0)begin // delete operation
		Buffer2[3*(counter2-4)-3]=0;
		Buffer2[3*(counter2-4)-2]=0;
		Buffer2[3*(counter2-4)-1]=0;
		deleted_data2 = deleted_data2 +1;	
	end
	if(read_data2-deleted_data2>0)begin // delete operation
		Buffer2[3*(counter2-5)-3]=0;
		Buffer2[3*(counter2-5)-2]=0;
		Buffer2[3*(counter2-5)-1]=0;
		deleted_data2 = deleted_data2 +1;	
	end
	if(read_data3-deleted_data3>0)begin // delete operation
		Buffer3[3*(counter3)-3]=0;
		Buffer3[3*(counter3)-2]=0;
		Buffer3[3*(counter3)-1]=0;
		deleted_data3 = deleted_data3 +1;	
	end
	if(read_data3-deleted_data3>0)begin // delete operation
		Buffer3[3*(counter3-1)-3]=0;
		Buffer3[3*(counter3-1)-2]=0;
		Buffer3[3*(counter3-1)-1]=0;
		deleted_data3 = deleted_data3 +1;	
	end
	if(read_data3-deleted_data3>0)begin // delete operation
		Buffer3[3*(counter3-2)-3]=0;
		Buffer3[3*(counter3-2)-2]=0;
		Buffer3[3*(counter3-2)-1]=0;
		deleted_data3 = deleted_data3 +1;	
	end
	if(read_data3-deleted_data3>0)begin // delete operation
		Buffer3[3*(counter3-3)-3]=0;
		Buffer3[3*(counter3-3)-2]=0;
		Buffer3[3*(counter3-3)-1]=0;
		deleted_data3 = deleted_data3 +1;	
	end
	if(read_data3-deleted_data3>0)begin // delete operation
		Buffer3[3*(counter3-4)-3]=0;
		Buffer3[3*(counter3-4)-2]=0;
		Buffer3[3*(counter3-4)-1]=0;
		deleted_data3 = deleted_data3 +1;	
	end
	if(read_data3-deleted_data3>0)begin // delete operation
		Buffer3[3*(counter3-5)-3]=0;
		Buffer3[3*(counter3-5)-2]=0;
		Buffer3[3*(counter3-5)-1]=0;
		deleted_data3 = deleted_data3 +1;	
	end
	if(read_data4-deleted_data4>0)begin // delete operation
		Buffer4[3*(counter4)-3]=0;
		Buffer4[3*(counter4)-2]=0;
		Buffer4[3*(counter4)-1]=0;
		deleted_data4 = deleted_data4 +1;	
	end
	if(read_data4-deleted_data4>0)begin // delete operation
		Buffer4[3*(counter4-1)-3]=0;
		Buffer4[3*(counter4-1)-2]=0;
		Buffer4[3*(counter4-1)-1]=0;
		deleted_data4 = deleted_data4 +1;	
	end
	if(read_data4-deleted_data4>0)begin // delete operation
		Buffer4[3*(counter4-2)-3]=0;
		Buffer4[3*(counter4-2)-2]=0;
		Buffer4[3*(counter4-2)-1]=0;
		deleted_data4 = deleted_data4 +1;	
	end
	if(read_data4-deleted_data4>0)begin // delete operation
		Buffer4[3*(counter4-3)-3]=0;
		Buffer4[3*(counter4-3)-2]=0;
		Buffer4[3*(counter4-3)-1]=0;
		deleted_data4 = deleted_data4 +1;	
	end
	if(read_data4-deleted_data4>0)begin // delete operation
		Buffer4[3*(counter4-4)-3]=0;
		Buffer4[3*(counter4-4)-2]=0;
		Buffer4[3*(counter4-4)-1]=0;
		deleted_data4 = deleted_data4 +1;	
	end
	if(read_data4-deleted_data4>0)begin // delete operation
		Buffer4[3*(counter4-5)-3]=0;
		Buffer4[3*(counter4-5)-2]=0;
		Buffer4[3*(counter4-5)-1]=0;
		deleted_data4 = deleted_data4 +1;	
	end
	
	if(start == 1) // starts to write
		control=1;
		c = control;
		int2=one && control;
	if(int2) begin
		temp[i] = 1;
		i = i+1;
		int3=1;
	end
	
	
	if(zero && control) begin
		temp[i] = 0;
		i = i+1;
	end
	int1=i;
		t=temp;
	if(i ==4)begin
		i=0;
		control =0;
		write =1;
	end
		w=write;
	if(write==1)begin
		if(temp[0] == 0 && temp[1] ==0)begin
			if(Buffer1[15] ==1)
				loss_data1 = loss_data1+1;				
			Buffer1 = Buffer1>>3;
			Buffer1[0]=1;
			Buffer1[1]=temp[2];
			Buffer1[2]=temp[3];
			write=0;
			wrote_data1 = wrote_data1+1;

		end
		if(temp[0] == 0 && temp[1] ==1)begin
			if(Buffer2[15] ==1)
				loss_data2 = loss_data2+1;	
			Buffer2 = Buffer2>>3;
			Buffer2[0]=1;
			Buffer2[1]=temp[2];
			Buffer2[2]=temp[3];
			write=0;
			wrote_data2 = wrote_data2+1;
		end
		if(temp[0] == 1 && temp[1] ==0)begin
			if(Buffer3[15] ==1)
				loss_data3 = loss_data3+1;	
			Buffer3 = Buffer3>>3;
			Buffer3[0]=1;
			Buffer3[1]=temp[2];
			Buffer3[2]=temp[3];
			write=0;
			wrote_data3 = wrote_data3+1;
			
		end
		if(temp[0] == 1 && temp[1] ==1)begin
			if(Buffer4[15] ==1)
				loss_data4 = loss_data4+1;	
			Buffer4 = Buffer4>>3;
			Buffer4[0]=1;
			Buffer4[1]=temp[2];
			Buffer4[2]=temp[3];
			write=0;			
			wrote_data4 = wrote_data4+1;
		end
	end
	
end

always @(posedge clock)begin // read command
	
	counter1=wrote_data1-loss_data1-deleted_data1;
	counter2=wrote_data2-loss_data2-deleted_data2;
	counter3=wrote_data3-loss_data3-deleted_data3;
	counter4=wrote_data4-loss_data4-deleted_data4;
	w1=wrote_data1;

	w4=wrote_data4;

	r1=deleted_data1;

	r4=deleted_data4;
	if(Buffer4[15] == 1 && read_data4-deleted_data4 ==0)begin
		  outputdata[0] = 1;
		  outputdata[1] = 1;
		  outputdata[2] = Buffer4[16];
		  outputdata[3] = Buffer4[17];
		  read_data4 = read_data4+1;

	end
	else if(Buffer3[15] == 1 && read_data3-deleted_data3 ==0)begin
		  outputdata[0] = 1;
        outputdata[1] = 0;
        outputdata[2] = Buffer3[16];
        outputdata[3] = Buffer3[17];
        read_data3 = read_data3+1;
    end
    else if(Buffer2[15] == 1 && read_data2-deleted_data2==0)begin
        outputdata[0] = 0;
        outputdata[1] = 1;
        outputdata[2] = Buffer2[16];
        outputdata[3] = Buffer2[17];

        read_data2 = read_data2+1;;
    end
    else if(Buffer1[15] == 1 && read_data1-deleted_data1==0)begin
        outputdata[0] = 0;
        outputdata[1] = 0;
        outputdata[2] = Buffer1[16];
        outputdata[3] = Buffer1[17];

        read_data1 = read_data1+1;
    end
    else if(counter1 >0)begin
        outputdata[0] = 0;
        outputdata[1] = 0;
        outputdata[2] = Buffer1[counter1*3-2];
        outputdata[3] = Buffer1[counter1*3-1];

		  read_data1 = read_data1+1;
    end
    else if(counter2 >0)begin
        outputdata[0] = 0;
        outputdata[1] = 1;
        outputdata[2] = Buffer2[counter2*3-2];
        outputdata[3] = Buffer2[counter2*3-1];

		  read_data2 = read_data2+1;
    end
    else if(counter3 >0)begin
        outputdata[0] = 1;
        outputdata[1] = 0;
        outputdata[2] = Buffer3[counter3*3-2];
        outputdata[3] = Buffer3[counter3*3-1];

		  read_data3 = read_data3+1;
    end
    else if(counter4 >0)begin
        outputdata[0] = 1;
        outputdata[1] = 1;
        outputdata[2] = Buffer4[counter4*3-2];
        outputdata[3] = Buffer4[counter4*3-1];

		  read_data4 = read_data4+1;
    end

end

endmodule
