`timescale 1ns/10ps
`define CYCLE       20
`define ENDCYCLE    100000
`define SDFFILE     "./layout/imgproc_APR.sdf"	  // Modify your sdf file name
`define PAT         "./data/pattern.dat"    
`define EXP         "./data/golden.dat"     


module testfixture();

    // parameter declare
    parameter N_EXP   = 16384; // 128 x 128 pixel
    parameter N_PAT   = N_EXP;
    parameter N_WID   = 128;
    integer     i, j;

    // register declare
    reg [7:0]   gray_mem   [0:N_PAT-1];
    reg [7:0]   exp_mem    [0:N_EXP-1];
    reg [7:0]   my_mem     [0:N_EXP-1];
    reg [7:0]   golden;
    reg [14:0]  err_count;

    reg         clk;
    reg         rst;
    reg [7:0]   orig_data;
    reg         orig_ready;
    wire [13:0] orig_addr;
    wire        request;
    wire [13:0] imgproc_addr;
    wire        imgproc_ready;
    wire [7:0]  imgproc_data;
    wire        finish;

    // module declare
    imgproc myName(clk,rst,orig_data,orig_ready,request,orig_addr,imgproc_ready,imgproc_addr,imgproc_data,finish);
    // for gate level netlist
    `ifdef SDF
        initial $sdf_annotate(`SDFFILE, myName);
    `endif

    // dump wave file
    initial begin
        $dumpfile("imgproc.vcd");
        $dumpvars(0,testfixture); 
    end

    // clock generate
    always #(`CYCLE/2) clk  = ~clk;

    // eat pattern and golden
    initial	$readmemh (`PAT, gray_mem);
    initial	$readmemh (`EXP, exp_mem);


    // -------------------  start here !!! ----------------------
    initial begin
        clk = 0;
        rst = 0;
        @(negedge clk)  rst = 1;
        #(`CYCLE*2)     rst = 0;
    
        while(finish == 0) begin
            @(negedge clk);
            if(request==1) begin
                orig_data= gray_mem[orig_addr];
                orig_ready=1;
            end
            else begin
                orig_data= 8'bz;
                orig_ready= 0;
            end
        end
        orig_data= 8'bz;
        orig_ready= 0;

    end

    // ------------------ verify !!! --------------------
    initial begin	
        $display("-----------------------------------------------------\n");
        $display("START!!! Simulation Start .....\n");
        $display("-----------------------------------------------------\n");
        err_count = 0;
        #(`CYCLE*3);
        i = 0;
        while(finish == 0 ) begin
            @(negedge clk);
            if(imgproc_ready) begin
                golden = exp_mem[i];
                i = i+1;
                my_mem[imgproc_addr] = imgproc_data;
            end
        end					

        #(`CYCLE);
        for(i=0;i<N_WID;i = i+1) begin
            for(j=0;j<N_WID;j = j+1)    begin
                if(i > 2 && i < N_WID-2 && j > 2 && j < N_WID-2)    begin
                    if(my_mem[i*N_WID+j]==exp_mem[i*N_WID+j]) begin
                        err_count = err_count;
                    end
                    else begin
                        $display("%dth Pixel is wrong :%h != %h !\n",i*N_WID+j,my_mem[i*N_WID+j],exp_mem[i*N_WID+j] );
                        err_count = err_count + 1;   
                    end
                end
            end
        end
        if ( err_count == 0) begin
            $display("===============================================\n");
            $display(" Congratulations!!! Every outputs are correct! \n");
            $display("===============================================\n");
            end
        else
            $display("The wrong pixels reached a total of %d or more ! \n", err_count);
        $finish;
    end

    // check time-out
    initial begin
        #(`CYCLE*`ENDCYCLE);
        $display("Time-out Error! Maybe there is something wrong with the 'finish' signal \n");
        $finish;
    end

endmodule

