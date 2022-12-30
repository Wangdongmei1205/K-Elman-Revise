%���㵤�������̫����λ�Ǻ�̫���߶Ƚ�
%����� MSTΪ����ʱ�� AΪ��λ�� HAΪ�߶Ƚ�
%                  beta     alpha


%����366���ܱ�4���� ƽ��365
function [alpha, beta] = Sun_angel(y, m, d)

%ƽ����������
pmonth = [31,28,31,30,31,30,31,31,30,31,30,31]; %ƽ��ÿ����
rmonth = [31,29,31,30,31,30,31,31,30,31,30,31]; %����ÿ����

%���뾭γ��
J = 105.18;
W = 39.742;

%�������
N = 0;
if mod(y,4)==0 && mod(y,100)~=0 || mod(y,400)==0 %����
    for i=1:m-1
        N = N+rmonth(i);
    end
else %ƽ��
    for i=1:m-1  %�������
        N = N+pmonth(i);
    end
end
N = N + d - 1; %��λ����

L = (J)/15; %�������� ��λ��Сʱ
Lc = -(J-112-4/60-35/3600)/15;
N0 = 79.6764+0.2422*(y-1985)-floor(0.25*(y-1985)); %��λ����
k = 1;
for Ct = 1/60-Lc:1/60:24-Lc %�ط���׼ʱ
    delta_N = (Ct+L)/24; %��λ����
    Q = 2*pi*57.3*(N+delta_N-N0)/365.2422;  %��λ:����
    EQ = 0.0028-1.9857*sind(Q)+9.9059*sind(2*Q)-7.0924*cosd(Q)-0.6882*cosd(2*Q); %��λ����
    MST(k) = Ct+Lc;%MSTʱ��
    TT = Ct+Lc+EQ/60;%��̫��ʱ  ��λ��Сʱ
    T0 = (TT-12)*15;%̫��ʱ�� ��λ����
    DE = 0.3723 + 23.2567*sind(Q) + 0.1149*sind(2*Q) - 0.1712*sind(3*Q) - 0.758*cosd(Q) + 0.3656*cosd(2*Q) + 0.0201*cosd(3*Q);
    %��γ ��λ:��
    HA(k) = asind(sind(W)*sind(DE)+cosd(W)*cosd(DE)*cosd(T0)); %̫���߶Ƚ�
    
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