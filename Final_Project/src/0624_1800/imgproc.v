module imgproc ( clk,rst,orig_data,orig_ready,request,orig_addr,imgproc_ready,imgproc_addr,imgproc_data,finish);
input   	    clk;
input   	    rst;
output  [13:0] 	orig_addr; //original: output reg [13:0] orig_addr;
output         	request;
input   	    orig_ready;
input   [7:0] 	orig_data;
output  [13:0] 	imgproc_addr;
output  	    imgproc_ready;
output  [7:0] 	imgproc_data;
output  	    finish;

//Macro declaration
parameter GAUSS_00 = 23'h00001a;
parameter GAUSS_01 = 23'h0000d8;
parameter GAUSS_02 = 23'h0001b5;
parameter GAUSS_03 = 23'h0000d8;
parameter GAUSS_04 = 23'h00001a;
parameter GAUSS_05 = 23'h0000d8;
parameter GAUSS_06 = 23'h000707;
parameter GAUSS_07 = 23'h000e41;
parameter GAUSS_08 = 23'h000707;
parameter GAUSS_09 = 23'h0000d8;
parameter GAUSS_10 = 23'h0001b5;
parameter GAUSS_11 = 23'h000e41;
parameter GAUSS_12 = 23'h001ce8;
parameter GAUSS_13 = 23'h000e41;
parameter GAUSS_14 = 23'h0001b5;
parameter GAUSS_15 = 23'h0000d8;
parameter GAUSS_16 = 23'h000707;
parameter GAUSS_17 = 23'h000e41;
parameter GAUSS_18 = 23'h000707;
parameter GAUSS_19 = 23'h0000d8;
parameter GAUSS_20 = 23'h00001a;
parameter GAUSS_21 = 23'h0000d8;
parameter GAUSS_22 = 23'h0001b5;
parameter GAUSS_23 = 23'h0000d8;
parameter GAUSS_24 = 23'h00001a;

parameter IDLE = 2'd0;
parameter IN = 2'd1;
parameter COMPUTE = 2'd2;
parameter OUT = 2'd3;

//reg declaration
reg request, next_request; //request previously declared
reg imgproc_ready, next_imgproc_ready; //imgproc_ready previously declared
reg finish, next_finish; //finish previously declared
reg [1:0] state, next_state;
reg [13:0] ori_data,next_ori_data;
reg [7:0]  imgproc_data, next_imgproc_data;
reg [13:0] imgproc_addr, next_imgproc_addr;
reg [7:0] row,next_row;
reg [7:0] now_row, now_col, next_now_row, next_now_col;
reg [7:0] temp_row;
reg [7:0] col,next_col;
reg [22:0] value;
integer i,j,k;

reg [7:0] array [0:127][0:127];
reg [7:0] block [0:4][0:127];
reg [7:0] temp_block [0:4];
//reg [7:0] next_block [0:4][0:127];
//reg [22:0] auss [0:4][0:4];


assign orig_addr = {now_row,now_col[6:0]};

//combinational part
always@(*)begin
//$display("orig_addr ", orig_addr);
//next_request=request;
next_imgproc_ready=0;
next_finish=0;
next_state=state;
next_request = 0;
//next_orig_addr=orig_addr;
next_imgproc_data=imgproc_data;
next_imgproc_addr=imgproc_addr;
next_row = row;
next_col = col;
next_now_row = now_row;
next_now_col = now_col;


for(i = 0;i< 128;i = i+1)
      for(j = 0;j < 128; j = j+1)
block[i][j] = block[i][j];

    case(state)
      IDLE:begin
        //$display("in IDLE");
        next_request = 1;
        next_state = IN;
	      next_finish = 0;
        next_imgproc_ready = 0;
      end

      IN:begin
       //$display("in IN");
       //$display("orig_addr ", orig_addr);
       //$display("col[7]", col[7]);
       //$display("row ", row);
       if(now_row[7]==1 && now_row[0] == 1) begin
          next_state=IDLE;
          next_finish=1;
          next_row=0;
          next_col=0;
          next_now_row = 0;
          next_now_col = 0;
          next_imgproc_ready = 0;
          //block[row][col] = block[row][col];
          end
	     else if(row[2]==1 && row[0]==1) begin
	      next_state=COMPUTE;
	      next_request = 0 ;
        next_now_row = now_row;
        next_now_col = 7'd0;
	      next_row = 0;
	      next_col = 0;
        next_imgproc_ready = 0;
        next_imgproc_addr = 0;
        next_imgproc_data = 0;
        $display("now_row", now_row);
        //block[row][col] = block[row][col];
	      end
	     else if(orig_ready  ) begin

         //$display("row[7] ", row[7]);
	       if(col[6]==1&&col[5]==1&&col[4]==1&&col[3]==1&&col[2]==1&&col[1]==1&&col[0]==1) begin
	        next_col=7'd0;
          next_now_col = 7'd0;
	        next_row = row+1;
          next_now_row = now_row + 1;
          next_request = 1;
          //$display("block[4][127]", block[4][127]);
          //$display(orig_data[7:0]);
          // next_col = col[6:0]+7'd1;
          // next_row = row+col[7];
	        end
	       else begin
          next_now_col = now_col[6:0] + 7'd1;
	        next_col = col[6:0]+7'd1;
          next_now_row = now_row;
          next_row = row ;
          next_request = 1;
	        end

	      block[row][col] = orig_data[7:0];
        //$display("orig_addr ", orig_addr );
	      //next_ori_data=ori_data+1;
	      end

       /*else if(orig_ready && now_row > 4) begin
          temp_block[0] = block[0][col];
          temp_block[1] = block[1][col];
          temp_block[2] = block[2][col];
          temp_block[3] = block[3][col];
          temp_block[4] = block[4][col];
          //row = 4;
          if(col[6]==1&&col[5]==1&&col[4]==1&&col[3]==1&&col[2]==1&&col[1]==1&&col[0]==1) begin
          next_col=7'd0;
          next_now_col = 7'd0;
          next_row = row + 1;
          next_now_row = now_row + 1;
          next_request = 1;
          
          //next_state = COMPUTE;
          // next_col = col[6:0]+7'd1;
          // next_row = row+col[7];
          end
         else begin
          next_col = col[6:0]+7'd1;
          next_now_col = now_col[6:0]+7'd1;
          next_now_row = now_row;
          next_row = row ;
          next_request = 1;
          end
        
        //block[row][col] = orig_data[7:0];

        //$display("block[1][col] ", block[1][col]);
        block[0][col] = temp_block[1];
        block[1][col] = temp_block[2];
        block[2][col] = temp_block[3];
        block[3][col] = temp_block[4];
        block[4][col] = orig_data[7:0];
        $display("block[4][127]", block[4][127]);
        $display(orig_data[7:0]);
        //$display("block[0][col] ", block[0][col]);
        //$display("orig_addr ", orig_addr );
        end*/

      end
      COMPUTE:begin
        //$display("now_row ", now_row);
        //$display("col ", col);
        value = 0;
        temp_row = now_row - 3;
        //$display("in COMPUTE");
        //$display("array[50][50] ", array[50][50]);
        //$display("imgproc_addr ", imgproc_addr);
	      if(now_row[7]==1 && now_row[0] == 1) begin
	        next_state=IDLE;
	        next_finish=1;
	        next_row=0;
	        next_col=0;
          next_now_row = 0;
          next_now_col = 0;
          next_imgproc_ready = 0;
	        end
        /*else if(row[2]==1 && row[0]==1)begin
          next_state = IN;
          next_request = 1;
          next_row = 0;
          next_imgproc_ready = 0;
          end*/
	      else begin
          next_imgproc_ready = 1;
          next_imgproc_addr = {temp_row, now_col[6:0]};
	        if(col[6]==1&&col[5]==1&&col[4]==1&&col[3]==1&&col[2]==1&&col[1]==1&&col[0]==1) begin
	          next_now_col = 7'd0;
            next_col = 7'd0;
            next_now_row = now_row - 4;
            //next_now_row = now_row;
	          next_row = 0 ;
            next_state = IN;
            next_request = 1;
            next_imgproc_ready = 0;
	          end
	        else begin
	          next_col=col[6:0]+1;
            next_now_col = now_col[6:0]+1;
            next_now_row = now_row;
            next_row = row;
	          end

          
          if(now_col>1 && now_col<126) begin //2~125
            value =  block[0][col-2]*GAUSS_00 + block[0][col-1]*GAUSS_01 + block[0][col]*GAUSS_02 + block[0][col+1]*GAUSS_03 + block[0][col+2]*GAUSS_04;
            value = value + block[1][col-2]*GAUSS_05 + block[1][col-1]*GAUSS_06 + block[1][col]*GAUSS_07 + block[1][col+1]*GAUSS_08 + block[1][col+2]*GAUSS_09;
            value = value + block[2][col-2]*GAUSS_10 + block[2][col-1]*GAUSS_11 + block[2][col]*GAUSS_12 + block[2][col+1]*GAUSS_13 + block[2][col+2]*GAUSS_14;
            value = value + block[3][col-2]*GAUSS_15 + block[3][col-1]*GAUSS_16 + block[3][col]*GAUSS_17 + block[3][col+1]*GAUSS_18 + block[3][col+2]*GAUSS_19;
            value = value + block[4][col-2]*GAUSS_20 + block[4][col-1]*GAUSS_21 + block[4][col]*GAUSS_22 + block[4][col+1]*GAUSS_23 + block[4][col+2]*GAUSS_24;

            if(value[14])
              next_imgproc_data = value[22:15] + 1;
            else if(!value[14])
              next_imgproc_data = value[22:15];

            //temp_row = now_row - 3;
            next_imgproc_addr = {temp_row, now_col[6:0]};
            //$display("imgproc_data ", imgproc_data);
            //next_state = OUT;
            next_imgproc_ready = 1;
            //$display("imgproc_data " , imgproc_data);
            //$display("now_row now_col ", now_row, " ", now_col);
            //$display("next_imgproc_addr", next_imgproc_addr);
	          end

	        else begin
            //next_imgproc_ready = 0;
            next_imgproc_addr =  {temp_row, now_col[6:0]};
	          next_imgproc_data = 0;
	          end

         //  next_imgproc_addr=orig_addr;
	        // next_state=OUT;
	        // next_imgproc_ready=1;
	        end
      end
      OUT:begin
	      next_state=COMPUTE;
	      next_imgproc_ready=0;
      end
   endcase
end


//sequential part
always@(posedge clk or posedge rst)
begin
  if(rst) begin
    state <= IDLE;
    now_row <= 0;
    now_col <= 0;
    request <= 1'b0;
    finish <= 1'b0;
    imgproc_ready <= 1'b0;
    imgproc_addr <= 14'd0;
    imgproc_data <= 8'd0;
    //ori_data <= 14'd0;
    row <= 0;
    col <= 0;

  end
  else begin
    state <= next_state;
    request <= next_request;
    finish <= next_finish;
    imgproc_ready <= next_imgproc_ready;
    imgproc_addr <= next_imgproc_addr;
    imgproc_data <= next_imgproc_data;
    ori_data <= next_ori_data;
    row <= next_row;
    col <= next_col;
    now_row <= next_now_row;
    now_col <= next_now_col;
    /*for(i = 0;i< 128;i = i+1)
      for(j = 0;j < 128; j = j+1)
    next_block[i][j] <= block[i][j];*/
  end
end


endmodule
