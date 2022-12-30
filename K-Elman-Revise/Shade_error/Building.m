function [building,N]=Building()
l=50;  %楼长
d=30; %楼宽
h=100;  %楼高
N=1;
building=[];

building(N,1)=0; %与正东方向夹角
building(N,2)=l; %楼长
building(N,3)=d;  %楼宽
building(N,4)=h;  %楼高
%与当前节点的位置
%建筑物最靠近南和西的点（a,b)为其坐标
a=0;
b=-40;
building(N,5)=a;
building(N,6)=b;

save('data/building.mat', 'building');
end



