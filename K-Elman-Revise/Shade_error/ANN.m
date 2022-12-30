function y_head = ANN(data_test_idx)
load('data/data19_10min');
data19_10min(find(data19_10min < 0)) = 0;
data = data19_10min;

x_temp = data(1:144, data_test_idx - 1);  % 所有行，预测当天前面的一列
y_head = [];

load('data/season');  % 用1234表示的四季
load('data/minp_ann');
load('data/maxp_ann');
load('data/mint_ann');
load('data/maxt_ann');
load('model/net_ann');
    
for i = 1:24
    for j = 1:6
        idx = (i-1)*6 + j;
        Xtest = [season(data_test_idx), floor((idx-1)/36)+1, x_temp(length(x_temp)-144+1: length(x_temp))']';
        Xtemp= tramnmx(Xtest,minp,maxp);
        PN=sim(net,Xtemp);  % 仿真
        y_head_temp = postmnmx(PN,mint,maxt);  % 仿真值反归一化
        x_temp = [x_temp; y_head_temp];
    end
    y_head = [y_head, mean(x_temp(length(x_temp)-5: length(x_temp)))];
    x_temp(length(x_temp)-5: length(x_temp)) = data((i-1)*6+1 : i*6, data_test_idx);
end
y_head = y_head';