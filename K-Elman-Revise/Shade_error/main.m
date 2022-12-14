clear
warning off
year  = 2019;
month = 1;

% 计算每天每分钟的太阳高度角和太阳方位角 共44640分钟

alpha = [];
beta = [];
predict_start =2;
predict_end = 60;
 
for date = 1:365  % 一年中每分钟的太阳高度角和方位角
    [alpha1, beta1] = Sun_angel(year, month, date);  %一天24*60=1440min
    alpha = [alpha alpha1];  %高度角1*525600  24*60*365
    beta = [beta beta1];  %方位角1*52600
end
%% 计算各节点当天被遮挡的时间段，返回 shade N个节点是否被遮挡的 0 1 矩阵 没被遮住为0，被遮住为1
load('data/building');  % building中记录的是建筑物与正东方向的夹角、建筑物长宽高、建筑物坐标（-1,0）生成与节点的横纵坐标的距离、建筑物与太阳高度角alpha和太阳方位角beta
shade = [];
%Shade(建筑物与正东方向的夹角theta, l, d, h, a, b, alpha, beta)
shade_temp = Shade(building(1),building(2),building(3),building(4),building(5),building(6),alpha,beta);
shade = shade_temp; % shade代表1年节点每分钟被遮挡的情况
%a=find(shade==1)    446---722  7:26-----12:02
%% 处理数据，生成经过阴影修正后的数据,data_min2019_nodes                                  
shade_energy = 6.33; 
Datahand(shade,shade_energy);
%% 预测
y_Elman = [];
y_IPro = [];
y_ANN = [];
y_test = [];
load('data/data_min2019_nodes.mat');
data19min_real = reshape(data_nodes, 1440,365);  %将一年内每分钟的充能量 表现形式为1440*365
for i= predict_start:predict_end    %  天数2：60
    test_idx=i;
    [y_Elman_day,y_ANN_day,y_IPro_day] = Forecast(test_idx,shade);  % 8*24
    y_Elman = [y_Elman y_Elman_day];
    y_ANN = [y_ANN y_ANN_day];
    y_IPro = [y_IPro y_IPro_day];
    
    y_test_day = data19min_real(:, test_idx); % 1440*1 一天内 %所有行的第test_idx列，即第test_idx天
    y_test_day = mean(reshape(y_test_day, 60, 24));  %60分钟*24小时
    y_test = [y_test y_test_day];
end
%% IPro预测误差
MAE_IPro = 0;
for i = 1:length(y_test)  % 1416小时   
    MAE_IPro = MAE_IPro+abs(y_test(i)- y_IPro(i));
end
MAE_IPro = MAE_IPro/(length(y_test));
%% ANN预测误差
MAE_ANN = 0;
for i = 1:length(y_test)
    MAE_ANN = MAE_ANN+abs(y_test(i)- y_ANN(i));
end
MAE_ANN = MAE_ANN/(length(y_test));
%% KE预测误差
MAE_KE = 0;
for i = 1:length(y_test)
    MAE_KE = MAE_KE+abs(y_test(i)- y_Elman(i));
end
MAE_KE = MAE_KE/(length(y_test));
%% 进行bar处理
MAE=[MAE_KE,MAE_ANN,MAE_IPro];
dataT=zeros(3,3);
for i=1:3
    dataT(i,i)=MAE(i);
end
MAE_KE_Vector=dataT(1,:);
MAE_ANN_Vector=dataT(2,:);
MAE_IPro_Vector=dataT(3,:);
%% 误差画图
f1=figure;
left_color = [0 0 0];
right_color = [0 0 0];
set(f1,'defaultAxesColorOrder',[left_color; right_color]);
grid on
yyaxis('left');
plot(y_test(1:96),'r-','LineWidth',2.5);   %真实值（1：96天）
hold on
plot(y_Elman(1:96),'b-','LineWidth',1.2);
hold on
plot(y_ANN(1:96),'-','Color',[0.69,0.19,0.38],'LineWidth',1.2);
hold on
plot(y_IPro(1:96),'-','Color',[1,0.6,0.07],'LineWidth',1.2);
hold on
xlabel('Time(h)','FontSize',18);
ylabel('Solar Irradiance(W/m^2)','FontSize',18);  % 设置x轴和y轴的名称
hold on;
ylim([0,300]);
yyaxis('right');
bar([30,35,40],MAE_KE_Vector,'FaceColor',[0,0,1],'BarWidth',2.2,'FaceAlpha',.15);
hold on
bar([45,50,55],MAE_ANN_Vector,'FaceColor',[0.69,0.19,0.38],'BarWidth',2.2,'FaceAlpha',.15);
hold on
bar([60,65,70],MAE_IPro_Vector,'FaceColor',[1,0.6,0.07],'BarWidth',2.2,'FaceAlpha',.15);
% h=bar([30,50,70],[MAE_KE,MAE_ANN,MAE_IPro],1,'FaceAlpha',.15);
ylabel('Error (W/m^2)','FontSize', 15);
ylim([0,35]);
% legend('Real','KER','ANN','IPro','KER','ANN','IPro','FontSize',8);
% hold on
legend('Real','KER','ANN','IPro');
% hg2 = legend(ah2, [h21 h22], 'Theory, trace 2', 'Experiment, trace 2', 0);
% set(hg2,'FontSize',LegendFontSize);
% hold on
% legend('Real','KER','ANN','IPro')
