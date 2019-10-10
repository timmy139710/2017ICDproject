module imgproc ( clk,rst,orig_data,orig_ready,request,orig_addr,imgproc_ready,imgproc_addr,imgproc_data,finish);
input   	    clk;
input   	    rst;
output  [13:0] 	orig_addr; 
output reg        	request;
input   	    orig_ready;
input   [7:0] 	orig_data;
output  [13:0] 	imgproc_addr;
output reg 	    imgproc_ready;
output  [7:0] 	imgproc_data;
output reg 	    finish;

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
reg next_request; //request previously declared
reg next_imgproc_ready; //imgproc_ready previously declared
reg next_finish; //finish previously declared
reg [1:0] state, next_state;
reg [13:0] prev_orig_addr,next_orig_addr;
reg [7:0] imgproc_data, next_imgproc_data;
reg [13:0] imgproc_addr, next_imgproc_addr;

reg [7:0] i,next_i;
reg [7:0] j,next_j;
reg [7:0] row,next_row;
reg [7:0] col,next_col;
reg [22:0] value;

reg [7:0] array [0:4][0:4];
reg [7:0] next_array [0:4][0:4];
reg [22:0] gauss [0:4][0:4];
integer k,l;

//assign orig_addr = {row+i-2,col[6:0]+j[6:0]-2};
assign orig_addr=prev_orig_addr;

//combinational part
always@(*)begin
//$display("orig_addr ", orig_addr);
//next_request=request;
next_imgproc_ready=0;
next_finish=0;
next_state=state;
next_request = 0;
next_orig_addr=prev_orig_addr;
next_imgproc_data=imgproc_data;
next_imgproc_addr=imgproc_addr;
next_row=row;
next_col=col;
next_array[0][0]=array[0][0];
next_array[0][1]=array[0][1];
next_array[0][2]=array[0][2];
next_array[0][3]=array[0][3];
next_array[0][4]=array[0][4];
next_array[1][0]=array[1][0];
next_array[1][1]=array[1][1];
next_array[1][2]=array[1][2];
next_array[1][3]=array[1][3];
next_array[1][4]=array[1][4];
next_array[2][0]=array[2][0];
next_array[2][1]=array[2][1];
next_array[2][2]=array[2][2];
next_array[2][3]=array[2][3];
next_array[2][4]=array[2][4];
next_array[3][0]=array[3][0];
next_array[3][1]=array[3][1];
next_array[3][2]=array[3][2];
next_array[3][3]=array[3][3];
next_array[3][4]=array[3][4];
next_array[4][0]=array[4][0];
next_array[4][1]=array[4][1];
next_array[4][2]=array[4][2];
next_array[4][3]=array[4][3];
next_array[4][4]=array[4][4];
next_i = i;
next_j = j;
  case(state) 
    IDLE:begin
        //$display("in IDLE");
      next_i=0;
      next_j=0;
      next_request = 1;
      next_state = IN;
      next_finish = 0;
      value=0;
      next_orig_addr=0;
    end

    IN:begin
      
      //$display("orig_addr ", orig_addr);
      //$display("col ", col);
      //$display("row ", row," col ",col);
      //$display("i ", i," j ", j);
      
      if(orig_ready) begin
        if(col>8'd1 && col<8'd126 && row>8'd1 && row<8'd126) begin
          //$display("orig_addr ", orig_addr);
          next_request=1;
          if(col>1 && col<6) begin
            if(i==5) begin
              next_state=COMPUTE;
              //$display("in IN1");
              next_request=0;
              next_i=0;
              next_j=0;
              if(col==5)
                next_orig_addr=prev_orig_addr-13'd635;
              else
                next_orig_addr=prev_orig_addr-13'd639;
            end
            else if(j==4) begin
              next_i=i+1;
              next_j=0;
              next_orig_addr=prev_orig_addr+124;
            end
            else begin
              next_j=j+1;
              next_i=i;
              next_orig_addr=prev_orig_addr+1;
            end
            //next_orig_addr={row+i-8'd2,col[6:0]+j[6:0]-7'd2};
            next_array[i][j]=orig_data[7:0];
          end
          else begin
            if(i==0) begin
              next_array[0][0]=array[0][1];
              next_array[0][1]=array[0][2];
              next_array[0][2]=array[0][3];
              next_array[0][3]=array[0][4];
              next_array[1][0]=array[1][1];
              next_array[1][1]=array[1][2];
              next_array[1][2]=array[1][3];
              next_array[1][3]=array[1][4];
              next_array[2][0]=array[2][1];
              next_array[2][1]=array[2][2];
              next_array[2][2]=array[2][3];
              next_array[2][3]=array[2][4];
              next_array[3][0]=array[3][1];
              next_array[3][1]=array[3][2];
              next_array[3][2]=array[3][3];
              next_array[3][3]=array[3][4];
              next_array[4][0]=array[4][1];
              next_array[4][1]=array[4][2];
              next_array[4][2]=array[4][3];
              next_array[4][3]=array[4][4];
            end
            
            if(i==5) begin
              next_state=COMPUTE;
              //$display("in IN1");
              next_request=0;
              next_i=0;
              next_j=0;
              next_orig_addr=prev_orig_addr-13'd639;
            end
            else begin
              next_i=i+1;
              next_j=j;
              next_orig_addr=prev_orig_addr+128;
            end
            
            //orig_addr={row+i-8'd2,col[6:0]+7'd2};
            next_array[i][4]=orig_data[7:0];
          end
        end
        else begin
          
          //$display("in IN2");
          //next_orig_addr={row,col[6:0]};
          if(col == 1 && row > 1  && row < 126)
            next_orig_addr = prev_orig_addr - 257;
          else 
            next_orig_addr={row,col[6:0]};
          next_imgproc_data=0;
          next_request=0;
          next_state=COMPUTE;
        end
      end
    end
      
    COMPUTE:begin
      //$display("in COMPUTE");
      value=0;
      if(row[7]==1) begin
        next_state=IDLE;
        next_finish=1;
        next_row=0;
        next_col=0;
      end
      else begin
        if(col[6]==1&&col[5]==1&&col[4]==1&&col[3]==1&&col[2]==1&&col[1]==1&&col[0]==1) begin
          next_col=0;
          next_row=row+1;
        end
        else begin
          if(col>0 && col<6) begin
            next_i=0;
            next_j=0;
          end
          else begin
            next_i=0;
            next_j=4;
          end
          next_col=col+1;
          next_row = row;
        end
        
        if(col>1 && col<126 && row>1 && row<126) begin //2~125
          value=array[0][0]*GAUSS_00+array[0][1]*GAUSS_01+array[0][2]*GAUSS_02+array[0][3]*GAUSS_03+array[0][4]*GAUSS_04;
          value=value+array[1][0]*GAUSS_05+array[1][1]*GAUSS_06+array[1][2]*GAUSS_07+array[1][3]*GAUSS_08+array[1][4]*GAUSS_09;
          value=value+array[2][0]*GAUSS_10+array[2][1]*GAUSS_11+array[2][2]*GAUSS_12+array[2][3]*GAUSS_13+array[2][4]*GAUSS_14;
          value=value+array[3][0]*GAUSS_15+array[3][1]*GAUSS_16+array[3][2]*GAUSS_17+array[3][3]*GAUSS_18+array[3][4]*GAUSS_19;
          value=value+array[4][0]*GAUSS_20+array[4][1]*GAUSS_21+array[4][2]*GAUSS_22+array[4][3]*GAUSS_23+array[4][4]*GAUSS_24;
                     
          
          //$display("value ",value);
          if(value[14])
            next_imgproc_data = value[22:15] + 1;
          else if(!value[14])
            next_imgproc_data = value[22:15];
            
          //$display("imgprooc_data ",next_imgproc_data);
        end
            
        next_imgproc_addr = {row,col[6:0]}-1;
        //$display("value ", value);
        //$display("imgproc_data ", imgproc_data);
        next_state = OUT;
        next_imgproc_ready = 1;
      end
    end
    
    OUT:begin
      //$display("in OUT");
      //$display("imgproc_addr ", imgproc_addr);
      if(row[7]==1) begin
        next_state=IDLE;
        next_finish=1;
        next_row=0;
        next_col=0;
      end

      next_state=IN;
      next_imgproc_ready=0;
      next_imgproc_addr=0;
      next_imgproc_data=0;
      next_request=1;
    end
  endcase
end


//sequential part
always@(posedge clk or posedge rst)
begin
  if(rst) begin
    state <= IDLE;
    request <= 1'b0;
    finish <= 1'b0;
    imgproc_ready <= 1'b0;
    imgproc_addr <= 14'd0;
    imgproc_data <= 8'd0;
    row <= 0;
    col <= 0;
  end
  else begin
    state <= next_state;
    request <= next_request;
    finish <= next_finish;
    prev_orig_addr <= next_orig_addr;
    imgproc_ready <= next_imgproc_ready;
    imgproc_addr <= next_imgproc_addr;
    imgproc_data <= next_imgproc_data;
    row <= next_row;
    col <= next_col;
    i <= next_i;
    j <= next_j;
    array[0][0]<=next_array[0][0];
    array[0][1]<=next_array[0][1];
    array[0][2]<=next_array[0][2];
    array[0][3]<=next_array[0][3];
    array[0][4]<=next_array[0][4];
    array[1][0]<=next_array[1][0];
    array[1][1]<=next_array[1][1];
    array[1][2]<=next_array[1][2];
    array[1][3]<=next_array[1][3];
    array[1][4]<=next_array[1][4];
    array[2][0]<=next_array[2][0];
    array[2][1]<=next_array[2][1];
    array[2][2]<=next_array[2][2];
    array[2][3]<=next_array[2][3];
    array[2][4]<=next_array[2][4];
    array[3][0]<=next_array[3][0];
    array[3][1]<=next_array[3][1];
    array[3][2]<=next_array[3][2];
    array[3][3]<=next_array[3][3];
    array[3][4]<=next_array[3][4];
    array[4][0]<=next_array[4][0];
    array[4][1]<=next_array[4][1];
    array[4][2]<=next_array[4][2];
    array[4][3]<=next_array[4][3];
    array[4][4]<=next_array[4][4];
  end
end


endmodule
