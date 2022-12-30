function y_head = Elman(data_test_idx)

load('data/hour_average1');  % 1*24 
load('data/centroids');    % 聚类的中心 k-means k=3
load('data/data19min');  % 1440*365  分钟数*天数
data19min(find(data19min < 0)) = 0;
%B = reshape(A,m,n)  将矩阵A的元素返回到一个m×n的矩阵B
%将2019年每天的数据(1440*365)->(1*(1440*365))
data19min = reshape(data19min, 1, size(data19min, 1)*size(data19min, 2));% 将2019年每天的数据(1440*365)->(1*(1440*365)) 一天有1440分钟
% 将2019年每天的数据(1440*365)->(60*8760)  8760代表一年的小时数，求均值前每列表示一小时中，每分钟的辐照度
%行：60分钟每分钟的辐照均值  列：从第i小时开始的辐照均值
%data19min 为60*8760  一年有8760个60分钟
data = mean(reshape(data19min, 60, 8760));   %data为1*8760，每列表示每小时的辐照均值
data = reshape(data, 24, 365);  % data为24*365 ，一年有365个24小时
x_temp = data(1:24, data_test_idx - 1);  % 预测天数前一天的每小时真实充能
y_head = [];
for i = 1:24
    Xtest = x_temp(end-23:end); % x_temp为24*1，前一天每小时的辐照均值
    Xtest = [Xtest', i, hour_average1(i)]; %1*24 
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