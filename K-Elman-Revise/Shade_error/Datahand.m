function Datahand(shade,shade_energy)   % 传入是否遮挡的01矩阵、32个节点、阴影时的充电功率10
load('data/data19min');  % 原来数据我改为0了，变量名为data_test为一个月的  1440（一天1440分钟）*365
data19min(find(data19min < 0)) = 0;
data19min_1 = reshape(data19min, 1, size(data19min, 1)*size(data19min, 2));  % 将数据转成1*525600(1440*365)列

data_nodes = data19min_1; 

for j=1:size(shade,2)  % size(shade,2)=44640 表示阴影的时间长度(覆盖），颗粒度为每分钟
    if shade(j)==1 
        data_nodes(j)=shade_energy;  %修改后的充能
    end
end
save('data/data_min2019_nodes.mat','data_nodes');  % 保存的是32个节点的每分钟的真实数据