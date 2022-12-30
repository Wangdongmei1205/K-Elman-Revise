%每十分钟的太阳辐照度
function y_head = ANN(data_test_idx)
load('data/data19_10min');
data19_10min(find(data19_10min < 0)) = 0;
data = data19_10min;

%取data中的所有行， data_test_idx - 1列
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
        %y = floor(x) 函数将x中元素取整，值y为不大于本身的最小整数；向下取整
        %season(data_test_idx)第data_test_idx天
        Xtest = [season(data_test_idx), floor((idx-1)/36)+1, x_temp(length(x_temp)-144+1: length(x_temp))']';
        %tramnmx语句的语法格式是：Xtest和 Xtemp分别为变换前、后的输入数据，maxp和minp分别为premnmx函数找到的最大值和最小值
        Xtemp= tramnmx(Xtest,minp,maxp);
        PN=sim(net,Xtemp);  % 仿真
        y_head_temp = postmnmx(PN,mint,maxt);  % 仿真值反归一化
        x_temp = [x_temp; y_head_temp];
    end
    y_head = [y_head, mean(x_temp(length(x_temp)-5: length(x_temp)))];
    x_temp(length(x_temp)-5: length(x_temp)) = data((i-1)*6+1 : i*6, data_test_idx);
end
y_head = y_head';