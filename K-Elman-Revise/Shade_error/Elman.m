function y_head = Elman(data_test_idx)

load('data/hour_average1');  % 1*25
load('data/centroids');
load('data/data19min');
data19min(find(data19min < 0)) = 0;
data19min = reshape(data19min, 1, size(data19min, 1)*size(data19min, 2));
data = mean(reshape(data19min, 60, 8760));  
data = reshape(data, 24, 365);   
x_temp = data(1:24, data_test_idx - 1);  % 预测前一天的每小时真实充能

y_head = [];
for i = 1:24
    Xtest = x_temp(end-23:end);
    Xtest = [Xtest', i, hour_average1(i)]; 
    idx = findClosestCentroids(Xtest, centroids);
    load(strcat('data/minp',num2str(idx)));
    load(strcat('data/maxp',num2str(idx)));
    load(strcat('data/mint',num2str(idx)));
    load(strcat('data/maxt',num2str(idx)));
    load(strcat('model/net',num2str(idx)));
    Xtemp= tramnmx(Xtest',minp,maxp);
    PN=sim(net,Xtemp); %仿真
    y_head = [y_head; postmnmx(PN,mint,maxt)]; %仿真值反归一化
    x_temp = [x_temp; data(i, data_test_idx)];
end
y_head = y_head';