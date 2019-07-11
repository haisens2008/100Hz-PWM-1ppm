// pwm out module
// author: shuaimou
// version: v1.0
// last modify date: 2018/12/31

////////module pwm (
////////    input           cpi,
////////    input           clr,
////////    output          out);
////////    
////////    parameter   high_level=50;             //define the high level of pwm
////////    
////////    reg [7:0]   division= 8'd200;          //the division of pwm,
////////    reg [7:0]   pluse;                     //计数值，最大对�56分屏
////////    reg [6:0]   count;                     //脉冲统计
////////    reg         out1;
////////    
////////    always@(*) begin
////////          pluse=division*high_level/100;   //比例换算成占空比，high_level/100即为0.8的占空比
////////    end
//////// 
////////    always @(posedge cpi or negedge clr) begin 
////////        if(!clr) begin
////////        count<=0;out1<=0; end                //复位
////////        else  begin if(count==division-1)
////////                            count<=0;
////////                    else    count<=count+1'b1;
////////                    if(count>=0&&count<pluse)     //在每一个脉冲的上升沿检测，如果count小于设定值，输出为高电平
////////                            out1<=1;
////////                    else    out1<=0; 
////////              end
////////     end      
////////     
////////     assign out=out1;   //去除毛刺，很重要�
////////endmodule



//pwm out module
//author: shuaimou
//version: v2.0
//last modify date: 2019/1/1
//period range: 0~65535
//pulse_width range: 0~period
module pwm(
        input               clk,                        // global clock
        input               reset_n,                    // global async low reset         
        output              out,                         // pwm output 
		  output              out_clk 
           );
        parameter           en=1;                       // pwm output enable, high enable
        parameter   [31:0]  period=500000;                // pwm period      1.5Khz
        parameter   [31:0]  pulse_width=1;            // pwm pulse width, must less or equal to pwm period   75%
        reg         [31:0]  cnt;
        reg                 wave;
    
    always @(posedge clk or negedge reset_n)    begin 
        if(!reset_n)
            cnt <= 0;
        else if(cnt<period-1 && en)
            cnt <= cnt + 1;
        else 
            cnt <= 0;
    end 
    
    always @(posedge clk or negedge reset_n)    begin
        if(!reset_n)
            wave <= 0;
        else if(cnt<pulse_width && en)
            wave <= 1;
        else 
            wave <= 0;
    end
    
        assign  out = wave;                 //Output is written to register and filtered
        assign  out_clk = clk;
endmodule
