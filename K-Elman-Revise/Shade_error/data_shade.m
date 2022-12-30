function [outputArg1,outputArg2] = data_shade()
% 将真实充能数据转换成一小时的充能数据，取平均值（W/m^2）
load('data/data_min2019_nodes.mat'); % N*44640
for i= 1:32
    for j=1:744
        nodes_real_energy_1hour31days(i,j) = mean(data_nodes(i,(j*60-59:j*60)));
    end
end
save('data/nodes_real_energy_1hour31days.mat','nodes_real_energy_1hour31days');