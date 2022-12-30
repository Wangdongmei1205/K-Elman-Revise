function y_head = Icc(idx)

load('data/data19min');
load('data/Eh_min');
% load('data/data18min');
len = 60; % Ԥ�ⲽ��

data_test = data19min(:, 1:idx);
data_test = reshape(data_test, 1, size(data_test, 1)*size(data_test, 2));
Eh_min = Eh_min(1 : idx*1440);
% Eh_min = [Eh_min Eh_min1];
% data_test = [data18min' data_test];
% disp(length(Eh_min));
% ���������ȴ�С
for i = 1:length(Eh_min)/len
    sum_Eh   = 0;
    sum_data = 0;
    for j = (i-1)*len+1:(i-1)*len+len
        sum_Eh = sum_Eh+Eh_min(j);
        sum_data = sum_data + data_test(j);
    end
    Eh1(i)   = sum_Eh/len;
    data_test1(i) = sum_data / len;
    if Eh1(i) ~= 0
        ratio(i) = data_test1(i)/Eh1(i);
    else
        ratio(i) = 0;
    end
end

%����Ԥ��ģ��
load('model/nets60');

%�����Ƕ�ratio��һЩ����Ȼ������Ԥ��ģ�ͣ�y�����
ratio = ratio';
data = ratio;

targetSeries = tonndata(data,false,false);
[xs,xis,ais,ts] = preparets(net,{},{},targetSeries);
y = net(xs,xis,ais);
y = cell2mat(y);
ts = cell2mat(ts);

%y��Ԥ�����ratio��ts��targets����ʵֵ
y = y(end - 24:end - 1);
Eh = Eh1(end - 24:end - 1);

y = y.*Eh;

y_head = y;