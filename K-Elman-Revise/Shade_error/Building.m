function [building,N]=Building()
l=50;  %¥��
d=30; %¥��
h=100;  %¥��
N=1;
building=[];

building(N,1)=0; %����������н�
building(N,2)=l; %¥��
building(N,3)=d;  %¥��
building(N,4)=h;  %¥��
%�뵱ǰ�ڵ��λ��
%����������Ϻ����ĵ㣨a,b)Ϊ������
a=0;
b=-40;
building(N,5)=a;
building(N,6)=b;

save('data/building.mat', 'building');
end



