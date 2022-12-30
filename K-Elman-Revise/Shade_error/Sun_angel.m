%计算丹佛地区的太阳方位角和太阳高度角
%结果中 MST为当地时间 A为方位角 HA为高度角
%                  beta     alpha


%闰年366，能被4整除 平年365
function [alpha, beta] = Sun_angel(y, m, d)

%平年闰年日数
pmonth = [31,28,31,30,31,30,31,31,30,31,30,31]; %平年每月日
rmonth = [31,29,31,30,31,30,31,31,30,31,30,31]; %闰年每月日

%输入经纬度
J = 105.18;
W = 39.742;

%计算积日
N = 0;
if mod(y,4)==0 && mod(y,100)~=0 || mod(y,400)==0 %闰年
    for i=1:m-1
        N = N+rmonth(i);
    end
else %平年
    for i=1:m-1  %计算积日
        N = N+pmonth(i);
    end
end
N = N + d - 1; %单位：日

L = (J)/15; %经度修正 单位：小时
Lc = -(J-112-4/60-35/3600)/15;
N0 = 79.6764+0.2422*(y-1985)-floor(0.25*(y-1985)); %单位：日
k = 1;
for Ct = 1/60-Lc:1/60:24-Lc %地方标准时
    delta_N = (Ct+L)/24; %单位：日
    Q = 2*pi*57.3*(N+delta_N-N0)/365.2422;  %单位:弧度
    EQ = 0.0028-1.9857*sind(Q)+9.9059*sind(2*Q)-7.0924*cosd(Q)-0.6882*cosd(2*Q); %单位：分
    MST(k) = Ct+Lc;%MST时间
    TT = Ct+Lc+EQ/60;%真太阳时  单位：小时
    T0 = (TT-12)*15;%太阳时角 单位：度
    DE = 0.3723 + 23.2567*sind(Q) + 0.1149*sind(2*Q) - 0.1712*sind(3*Q) - 0.758*cosd(Q) + 0.3656*cosd(2*Q) + 0.0201*cosd(3*Q);
    %赤纬 单位:度
    HA(k) = asind(sind(W)*sind(DE)+cosd(W)*cosd(DE)*cosd(T0)); %太阳高度角
    
    A(k) = asind(-cosd(DE)*sind(T0)/cosd(HA(k)));
    
    k = k+1;
end

for i=1:length(A)/2
    if A(i+1) < A(i)
        t1 = i;
        break;
    end
end

for i=floor(length(A)/2):length(A)
    if A(i+1) > A(i)
        t2 = i;
        break;
    end
end

for i=1:length(A)
    if i>t1 && i<=t2
        A(i) = 180-A(i);
    end
    if i>t2
        A(i) = 360+A(i);
    end
end
beta = A;
alpha = HA;