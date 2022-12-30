function y_head = Elman(data_test_idx)

load('data/hour_average1');  % 1*24 
load('data/centroids');    % ��������� k-means k=3
load('data/data19min');  % 1440*365  ������*����
data19min(find(data19min < 0)) = 0;
%B = reshape(A,m,n)  ������A��Ԫ�ط��ص�һ��m��n�ľ���B
%��2019��ÿ�������(1440*365)->(1*(1440*365))
data19min = reshape(data19min, 1, size(data19min, 1)*size(data19min, 2));% ��2019��ÿ�������(1440*365)->(1*(1440*365)) һ����1440����
% ��2019��ÿ�������(1440*365)->(60*8760)  8760����һ���Сʱ�������ֵǰÿ�б�ʾһСʱ�У�ÿ���ӵķ��ն�
%�У�60����ÿ���ӵķ��վ�ֵ  �У��ӵ�iСʱ��ʼ�ķ��վ�ֵ
%data19min Ϊ60*8760  һ����8760��60����
data = mean(reshape(data19min, 60, 8760));   %dataΪ1*8760��ÿ�б�ʾÿСʱ�ķ��վ�ֵ
data = reshape(data, 24, 365);  % dataΪ24*365 ��һ����365��24Сʱ
x_temp = data(1:24, data_test_idx - 1);  % Ԥ������ǰһ���ÿСʱ��ʵ����
y_head = [];
for i = 1:24
    Xtest = x_temp(end-23:end); % x_tempΪ24*1��ǰһ��ÿСʱ�ķ��վ�ֵ
    Xtest = [Xtest', i, hour_average1(i)]; %1*24 
    idx = findClosestCentroids(Xtest, centroids);
    load(strcat('data/minp',num2str(idx)));
    load(strcat('data/maxp',num2str(idx)));
    load(strcat('data/mint',num2str(idx)));
    load(strcat('data/maxt',num2str(idx)));
    load(strcat('model/net',num2str(idx)));
    Xtemp= tramnmx(Xtest',minp,maxp);
    PN=sim(net,Xtemp); %����
    y_head = [y_head; postmnmx(PN,mint,maxt)]; %����ֵ����һ��
    x_temp = [x_temp; data(i, data_test_idx)];
end
y_head = y_head';