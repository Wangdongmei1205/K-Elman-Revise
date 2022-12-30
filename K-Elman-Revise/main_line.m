clear    %清除Workspace种各类型的数据，使后续程序变量之间不会冲突
warning off
load('./data/data19min');
data19min(find(data19min < 0)) = 0; %返回行标
%% 预测
y_Elman = [];
y_IPro = [];
y_ANN = [];
y_test = [];
for i =2:60  
    %各个方法的24个小时预测值 1*24
    test_idx=i;
    y_IPro_day = IPro(test_idx);  %预测当前时刻，取预测时刻之前的两个小时的充能，从18年数据中选出天气最相近的两天辐照度，根据其来预测预测时刻
    y_ANN_day  = ANN(test_idx)';  % 
    y_Elman_day = Elman(test_idx);                                                                                                                                                                             

    y_IPro_day(find(y_IPro_day < 0)) = 0;
    y_ANN_day(find(y_ANN_day < 0)) = 0;
    y_Elman_day(find(y_Elman_day < 0)) = 0;
    
    y_Elman = [y_Elman y_Elman_day];
    y_ANN = [y_ANN y_ANN_day];
    y_IPro = [y_IPro y_IPro_day];
   
    %% 真实数据
    %第test_idx天的每分钟的太阳辐照度1440*1
    y_test_day = data19min(:, test_idx);  % 预测当天每分钟的太阳辐照度
     %reshape将矩阵y_test_day的元素返回到一个60*24的矩阵,  行：小时  列：分钟                                                                                                                                                                                                                      
    y_test_day = mean(reshape(y_test_day, 60, 24)); %mean均值1*24 列：代表每小时的太阳辐照均值
    y_test = [y_test y_test_day]; %将两个矩阵合并，1*24 代表第i天每小时的太阳辐照均值  %随着i的取值列增多
end
%% IPro预测误差
%y_test是真实的平均太阳辐照均值误差，y_IPro为Ipro算法的误差
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
set(0,'defaultfigurecolor','w')
f1=figure;
left_color = [0 0 0];
right_color = [0 0 0];
set(f1,'defaultAxesColorOrder',[left_color; right_color]);
grid on
yyaxis('left');
plot(y_test(1:96),'r-','LineWidth',2.5);
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
 set(gca,'YTick',[0:50:300]);

yyaxis('right');
bar([30,35,40],MAE_KE_Vector,'FaceColor',[0,0,1],'BarWidth',2.2,'FaceAlpha',.15);
hold on
bar([45,50,55],MAE_ANN_Vector,'FaceColor',[0.69,0.19,0.38],'BarWidth',2.2,'FaceAlpha',.15);
hold on
bar([60,65,70],MAE_IPro_Vector,'FaceColor',[1,0.6,0.07],'BarWidth',2.2,'FaceAlpha',.15);
% h=bar([30,50,70],[MAE_KE,MAE_ANN,MAE_IPro],1,'FaceAlpha',.15);

ylabel('Error (W/m^2)','FontSize', 18);
 ylim([0,35]);
set(gca,'YTick',[0:5:35]);
legend('Real','KER','ANN','IPro');
%set(gca,'FontName','Microsoft Yahei','FontSize',10);





