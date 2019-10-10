module SET ( clk , rst, en, central, radius, busy, valid, candidate );

input clk, rst;
input en;
input [7:0] central;
input [3:0] radius;
output busy;
output valid;
output [7:0] candidate;

//Macro declaration for FSM
parameter IDLE = 2'b00;
parameter COMPUTE = 2'd1;
parameter OUT = 2'd2;

//reg wired declaration
reg busy, next_busy;
reg valid, next_valid;
reg [1:0] state, next_state;
reg [7:0] candidate, next_candidate;
reg signed [3:0] cenx,next_cenx;
reg signed [3:0] ceny,next_ceny;
reg signed [3:0] x,next_x;
reg signed [3:0] y,next_y;
reg [7:0] r,next_r;
reg [8:0] distance;

//combinational part
always@(*)
begin
  case(state)
    IDLE:begin
      next_cenx = central[7:4];
      next_ceny = central[3:0];
      next_r = radius[3:0];
      next_x = -7;
      next_y = -7;
      next_candidate = 0;
      next_valid = 0;

      if(en == 1'b1) begin
        next_state = COMPUTE;
        next_busy = 1;
        //$display("en ==1");
        //$display("x",x);
        //$display("y",y);
        //$display("cenx ",next_cenx);
        //$display("cnetral[7:4]", central[7:4]);
        //$display("cnetral[3:0]", central[3:0]);
        //$display("ceny ",next_ceny);
        //$display("r",next_r);
      end
      else begin
        next_state=IDLE;
        next_busy = 0;
      end
    end

    COMPUTE:begin
      next_busy = 1;
      next_cenx = cenx;
      next_ceny = ceny;
      next_r = r;
      distance =(x-cenx)**2+(y-ceny)**2;

      if(distance < r**2) begin
        next_candidate = candidate + 1;
      end
      else
        next_candidate = candidate;

        //$display("cen_x_r",cen_x_r);
    	  //$display("cen_y_r",cen_y_r);
    	  //$display("x",x);
    	  //$display("y",y);

    if(x != 7) begin
      next_x = x + 1;
      next_y = y;
      next_state = COMPUTE;
      next_valid = 0;
      end
    else if(x == 7 && y!= 7) begin
      next_y = y + 1;
      next_x = -7;
      next_state = COMPUTE;
      next_valid = 0;
      end

    if((x == 7) && (y == 7)) begin
      next_x = -7;
      next_y = -7;
      next_valid = 1;
      next_state = OUT;
    end
    //$display("next_state",next_state);
    end

    OUT:begin
      //$display("valid",valid);
      next_x = -7;
      next_y = -7;
      next_cenx = 0;
      next_ceny = 0;
      next_r = 0;
      next_busy = 0;
      next_valid = 0;
      next_state = IDLE;
      next_candidate = candidate;
    end

    default:begin
      next_state = state;
      next_candidate = candidate;
      next_valid = valid;
      next_busy = busy;
      next_cenx = cenx;
      next_ceny = ceny;
      next_r = r;
      next_x = x;
      next_y = y;
    end
  endcase
end


//sequential part
always@(posedge clk or posedge rst)
begin
  if(rst) begin
    state <= IDLE;
    candidate <= 8'd0;
    busy <= 1'b0;
    valid <= 1'b0;
    candidate <= 8'd0;
    r <= 16'd0;
  end
  else begin
    state <= next_state;
    valid <= next_valid;
    busy <= next_busy;
    candidate <= next_candidate;
    x <= next_x;
    y <= next_y;
    cenx <= next_cenx;
    ceny <= next_ceny;
    r <= next_r;
  end
end

endmodule
