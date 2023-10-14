// 409510049 409335047

module JAM (
input CLK,
input RST,
output reg [2:0] W,
output reg [2:0] J,
input [6:0] Cost,
output reg [3:0] MatchCount,
output reg [9:0] MinCost,
output reg Valid );

initial begin
    $dumpfile("JAM.vcd");
    $dumpvars(0, testfixture);
    //for(i = 0; i < 8; i = i+1)
        //$dumpvars(1, num[i]);
end

reg [5:0]state;
reg [2:0]num[0:7];
reg [2:0]back_num[0:7];
reg [3:0]ans_count; //MatchCount
reg [9:0]ans_min;   //MinCost 初始化為1023
reg [15:0]count;    //計算做到第幾組的組合
reg [15:0]sum_cost;
reg [15:0] i;
reg [15:0] r;
reg [15:0] change_point1;  //第1個替換點
reg [15:0] change_point2;  //第2個替換點
reg [15:0] right_min; //第一個替換點右邊比替換點大的最小數


always @(posedge CLK or posedge RST) 
begin
    if(RST)
    begin
        state <= 0;
        num[0] <= 0;
        num[1] <= 1;
        num[2] <= 2;
        num[3] <= 3;
        num[4] <= 4;
        num[5] <= 5;
        num[6] <= 6;
        num[7] <= 7;
        back_num[0] <= 0;
        back_num[1] <= 0;
        back_num[2] <= 0;
        back_num[3] <= 0;
        back_num[4] <= 0;
        back_num[5] <= 0;
        back_num[6] <= 0;
        back_num[7] <= 0;
        ans_count <= 0;
        ans_min <= 1023;
        count <= 1;
        sum_cost <= 0;
        i <= 0;
        r <= 7;
        
    end
    
    else 
    begin
    	case(state)
    	
    		5'd0:   //算出cost
    		begin
    		
    			W <= i;
    			J <= num[i];
    			
    			if(i>0)begin
    			
    				sum_cost <= sum_cost + Cost;
    			end
    			
    			i <= i + 1;
    			state <= 0;
    			if(i == 8)begin   //累加到最後一個離開去比對cost
    				W <= i;
    				J <= num[i];
    				sum_cost <= sum_cost + Cost;
				state <= 1;
    			end
    			

    		end
    		
    		5'd1:
    		begin
    			//$display("%d %d %d %d %d %d %d %d\n",num[0],num[1],num[2],num[3],num[4],num[5],num[6],num[7]);
    			//$display("sum_cost:%d\n",sum_cost);
    			if(sum_cost < ans_min)   //當算出來的cost小於目前最小的cost
    			begin
    				
    				ans_min <= sum_cost;
    				ans_count <= 1;  //回歸到1
    				
    			end
    			
    			else if(sum_cost == ans_min)  //當算出來的cost等於目前的cost,Match_count+1;
    			begin
    				ans_count <= ans_count + 1;
    			end
    			
    			else   //如果算出來的cost大於目前最小的cost
    			begin	
    			
    			end
    			
    			if( num[0]==7 && num[1]==6 && num[2]==5 && num[3]==4 && num[4]==3 && num[5]==2 && num[6]==1 && num[7]==0)
    			begin  //如果到最後一組，計算完要印出
    				MatchCount <= ans_count;
    				MinCost <= ans_min;
    				Valid <= 1;
    			end
    			
    			r <= 7;
    			//字典排序，計算下一組
    			//找右邊比左邊大
    			if(num[7]>num[6])begin
    				change_point1 <= 6;  //位置
    				i <= 7;
    				change_point2 <= 7;
    				right_min <= num[7];  //初始為下一個
    				state <= 2;
    			end
    			else if(num[6]>num[5])begin
    				change_point1 <= 5;  //位置
    				i <= 6;
    				change_point2 <= 6;
    				right_min <= num[6];  //初始為下一個
    				state <= 2;
    			end
    			else if(num[5]>num[4])begin
    				change_point1 <= 4;  //位置
    				i <= 5;
    				change_point2 <= 5;
    				right_min <= num[5];  //初始為下一個
    				state <= 2;
    			end
    			else if(num[4]>num[3])begin
    				change_point1 <= 3;  //位置
    				i <= 4;
    				change_point2 <= 4;
    				right_min <= num[4];  //初始為下一個
    				state <= 2;
    			end
    			else if(num[3]>num[2])begin
    				change_point1 <= 2;  //位置
    				i <= 3;
    				change_point2 <= 3;
    				right_min <= num[3];  //初始為下一個
    				state <= 2;
    			end
    			else if(num[2]>num[1])begin
    				change_point1 <= 1;  //位置
    				i <= 2;
    				change_point2 <= 2;
    				right_min <= num[2];  //初始為下一個
    				state <= 2;
    			end
    			else if(num[1]>num[0])begin
    				change_point1 <= 0;  //位置
    				i <= 1;
    				change_point2 <= 1;
    				right_min <= num[1];  //初始為下一個
    				state <= 2;
    			end
    			
    			
    		end
    		
    		5'd2:   //找第2個替換點
    		begin
    			if(i <= 7)
    			begin

    				i <= i + 1;
    				if(num[i] < right_min && num[i] > num[change_point1] )  //如果有找到比它更小的
    				begin
    					right_min <= num[i];
    					change_point2 <= i;
    					
    				end
    				
    			end
    			
    			else   //找完替換點(交換swap)
    			begin
    				
    				num[change_point1] <= num[change_point2];
    				num[change_point2] <= num[change_point1];	
    				r <= 0;
    				state <= 3;
    				
    			end
    			
    			
    		end
    		5'd3:
    		begin
    			back_num[0] <= num[7];
    			back_num[1] <= num[6];
    			back_num[2] <= num[5];
    			back_num[3] <= num[4];
    			back_num[4] <= num[3];
    			back_num[5] <= num[2];
    			back_num[6] <= num[1];
    			back_num[7] <= num[0];
    			change_point1 <= change_point1 + 1;
    			r <= 0;
    			
    			state <= 4;
    		end
    		
    		
    		5'd4:    //將後面的值倒過來
    		begin
    			/*
    			num[change_point1] <= back_num[r]; 
    			change_point1 <= change_point1 + 1;
    			r <= r + 1;
    			if(change_point1==8)begin  //交換完回到case0計算cost
    				i <= 0;
    				r <= 7;
    				sum_cost <= 0;
    				state <= 0;  //先直接結束
    			end*/
    			
    			if(change_point1 == 7)
    			begin
    				num[7] <= back_num[0];
    				i <= 0;
    				r <= 7;
    				sum_cost <= 0;
    				state <= 0;
    			end
    			else if(change_point1 == 6)
    			begin
    				num[6] <= back_num[0];
    				num[7] <= back_num[1];
    				i <= 0;
    				r <= 7;
    				sum_cost <= 0;
    				state <= 0;
    			end
    			else if(change_point1 == 5)
    			begin
    				num[5] <= back_num[0];
    				num[6] <= back_num[1];
    				num[7] <= back_num[2];
    				i <= 0;
    				r <= 7;
    				sum_cost <= 0;
    				state <= 0;
    			end
    			else if(change_point1 == 4)
    			begin
    				num[4] <= back_num[0];
    				num[5] <= back_num[1];
    				num[6] <= back_num[2];
    				num[7] <= back_num[3];
    				i <= 0;
    				r <= 7;
    				sum_cost <= 0;
    				state <= 0;
    			end
    			else if(change_point1 == 3)
    			begin
    				num[3] <= back_num[0];
    				num[4] <= back_num[1];
    				num[5] <= back_num[2];
    				num[6] <= back_num[3];
    				num[7] <= back_num[4];
    				i <= 0;
    				r <= 7;
    				sum_cost <= 0;
    				state <= 0;
    			end
    			else if(change_point1 == 2)
    			begin
    				num[2] <= back_num[0];
    				num[3] <= back_num[1];
    				num[4] <= back_num[2];
    				num[5] <= back_num[3];
    				num[6] <= back_num[4];
    				num[7] <= back_num[5];
    				i <= 0;
    				r <= 7;
    				sum_cost <= 0;
    				state <= 0;
    			end
    			else if(change_point1 == 1)
    			begin
    				num[1] <= back_num[0];
    				num[2] <= back_num[1];
    				num[3] <= back_num[2];
    				num[4] <= back_num[3];
    				num[5] <= back_num[4];
    				num[6] <= back_num[5];
    				num[7] <= back_num[6];
    				i <= 0;
    				r <= 7;
    				sum_cost <= 0;
    				state <= 0;
    			end
    			else if(change_point1 == 0)
    			begin
    				num[0] <= back_num[0];
    				num[1] <= back_num[1];
    				num[2] <= back_num[2];
    				num[3] <= back_num[3];
    				num[4] <= back_num[4];
    				num[5] <= back_num[5];
    				num[6] <= back_num[6];
    				num[7] <= back_num[7];
    				i <= 0;
    				r <= 7;
    				sum_cost <= 0;
    				state <= 0;
    			end
    			
    		end
    		
    		
    	endcase

    end
end



endmodule

//$display("%d %d %d %d %d %d %d %d\n",num[0],num[1],num[2],num[3],num[4],num[5],num[6],num[7]);

/*5'd2:   //字典排序，計算下一組
    		begin
    			if(num[r]>num[r-1])  //右邊比左邊大（找到）
    			begin
    			
    				change_point1 <= r - 1;  //位置
    				i <= r;
    				change_point2 <= r;
    				right_min <= num[r];  //初始為下一個
    				state <= 3;
    				
    				
    			end
    			
    			else
    			begin
    				r <= r - 1;
    				state <= 2;
    			end
    			
    		end*/

