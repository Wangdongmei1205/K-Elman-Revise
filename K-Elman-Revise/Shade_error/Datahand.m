function Datahand(shade,shade_energy)   % �����Ƿ��ڵ���01����32���ڵ㡢��Ӱʱ�ĳ�繦��10
load('data/data19min');  % ԭ�������Ҹ�Ϊ0�ˣ�������Ϊdata_testΪһ���µ�  1440��һ��1440���ӣ�*365
data19min(find(data19min < 0)) = 0;
data19min_1 = reshape(data19min, 1, size(data19min, 1)*size(data19min, 2));  % ������ת��1*525600(1440*365)��

data_nodes = data19min_1; 

for j=1:size(shade,2)  % size(shade,2)=44640 ��ʾ��Ӱ��ʱ�䳤��(���ǣ���������Ϊÿ����
    if shade(j)==1 
        data_nodes(j)=shade_energy;  %�޸ĺ�ĳ���
    end
end
save('data/data_min2019_nodes.mat','data_nodes');  % �������32���ڵ��ÿ���ӵ���ʵ����