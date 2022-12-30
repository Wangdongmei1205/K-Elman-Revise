%ÿʮ���ӵ�̫�����ն�
function y_head = ANN(data_test_idx)
load('data/data19_10min');
data19_10min(find(data19_10min < 0)) = 0;
data = data19_10min;

%ȡdata�е������У� data_test_idx - 1��
x_temp = data(1:144, data_test_idx - 1);  % �����У�Ԥ�⵱��ǰ���һ��
y_head = [];

load('data/season');  % ��1234��ʾ���ļ�
load('data/minp_ann'); 
load('data/maxp_ann');
load('data/mint_ann');
load('data/maxt_ann');
load('model/net_ann');

for i = 1:24
    for j = 1:6
        idx = (i-1)*6 + j;
        %y = floor(x) ������x��Ԫ��ȡ����ֵyΪ�����ڱ������С����������ȡ��
        %season(data_test_idx)��data_test_idx��
        Xtest = [season(data_test_idx), floor((idx-1)/36)+1, x_temp(length(x_temp)-144+1: length(x_temp))']';
        %tramnmx�����﷨��ʽ�ǣ�Xtest�� Xtemp�ֱ�Ϊ�任ǰ������������ݣ�maxp��minp�ֱ�Ϊpremnmx�����ҵ������ֵ����Сֵ
        Xtemp= tramnmx(Xtest,minp,maxp);
        PN=sim(net,Xtemp);  % ����
        y_head_temp = postmnmx(PN,mint,maxt);  % ����ֵ����һ��
        x_temp = [x_temp; y_head_temp];
    end
    y_head = [y_head, mean(x_temp(length(x_temp)-5: length(x_temp)))];
    x_temp(length(x_temp)-5: length(x_temp)) = data((i-1)*6+1 : i*6, data_test_idx);
end
y_head = y_head';