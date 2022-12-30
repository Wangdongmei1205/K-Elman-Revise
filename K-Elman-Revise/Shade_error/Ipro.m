function y_head = Ipro(idx)
%% 处理19年每分钟的数据
load('data/data19min');  % 525600*1  
data19min(find(data19min < 0)) = 0;
data19min = reshape(data19min, 1, size(data19min, 1)*size(data19min, 2));  % 将2019年每天的数据(1440*365)->(1*(1440*365)) 一天有1440分钟
data19 = mean(reshape(data19min, 60, 8760));  % 将2019年每天的数据(1440*365)->(60*8760)  8760代表一年的小时数，求均值前每列表示一小时中，每分钟的辐照度
data19hour = reshape(data19, 24, 365);  % data为1*8760，每列表示每天每小时的辐照均值，24*365
%% 处理18年每分钟的数据
load('data/data18min');  % 525600*1  
data18min(find(data18min < 0)) = 0;
data18min = reshape(data18min, 1, size(data18min, 1)*size(data18min, 2)); 
data18 = mean(reshape(data18min, 60, 8760)); 
data18hour = reshape(data18, 24, 365); 

y_head = [];
for current_time = 1:24
    if current_time == 1
        Ca = data19hour(24, idx-1);  %19年预测前一天24点
        Cb = data19hour(23, idx-1);  %19年预测前一天23点
    else
        if current_time == 2
            Ca = data19hour(1, idx);  %19年第2天1点
            Cb = data19hour(24, idx-1);  %19年第一天24点
        else
            Ca = data19hour(current_time - 1, idx);%19年第2天预测前1点
            Cb = data19hour(current_time - 2, idx);%19年第2天预测前2点
        end
    end %计算预测时刻之前的两个小时的充能

    sim_a = -1;
    sim_b = -1; %记录最相似的那两天的序号
    mae_a = inf;
    mae_b = inf; %记录mae的最小值和次小值
    for i = 2:365 %从18年一整年中选出天气相似的
        if current_time == 1 %1点前为23 24
            Xa = data18hour(24, i-1); %18年1~364天的24和23点的充能   Xa代表预测前1个小时的充能
            Xb = data18hour(23, i-1);%Xb代表预测前2个小时的充能
        else
            if current_time == 2   %2点前为24 1
                Xa = data18hour(1, i);%2到365天的1点
                Xb = data18hour(24, i-1); %1~364天的24点
            else %其他为
                Xa = data18hour(current_time - 1, i);
                Xb = data18hour(current_time - 2, i);
            end
        end
        mae = abs(Ca-Xa)/2 + abs(Cb-Xb)/2;
        if mae < mae_b
            if mae < mae_a
                mae_b = mae_a;
                sim_b = sim_a;
                mae_a = mae;
                sim_a = i;
            else
                mae_b = mae;
                sim_b = i;
            end
        end
    end
    %选出的两天近似日分别为sim_a和sim_b
    %对应的mae分别为mae_a和mae_b
    if mae_a+mae_b ~= 0
        w_a = 1-mae_a/(mae_a+mae_b);
        w_b = 1-mae_b/(mae_a+mae_b);
    else
        w_a = 1;
        w_b = 1;
    end
    %计算相似日的对应时间段的辐射强度
    O_a = data18hour(current_time, sim_a);
    O_b = data18hour(current_time, sim_b);
    WP = w_a*O_a + w_b*O_b;
    if Ca+Cb ~= 0
        Sx = 0.5*((Ca-Cb)*2/(Ca+Cb))*Cb;
    else
        Sx = 0;
    end
    pre = 0.7*Ca + 0.3*WP + Sx; % 预测值
    if pre < 0
        pre = 0;
    end
    y_head = [y_head, pre];
    data(current_time, idx) = pre;
end