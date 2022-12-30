clear
warning off
year  = 2019;
month = 1;

% ����ÿ��ÿ���ӵ�̫���߶ȽǺ�̫����λ�� ��44640����

alpha = [];
beta = [];
predict_start =2;
predict_end = 60;
 
for date = 1:365  % һ����ÿ���ӵ�̫���߶ȽǺͷ�λ��
    [alpha1, beta1] = Sun_angel(year, month, date);  %һ��24*60=1440min
    alpha = [alpha alpha1];  %�߶Ƚ�1*525600  24*60*365
    beta = [beta beta1];  %��λ��1*52600
end
%% ������ڵ㵱�챻�ڵ���ʱ��Σ����� shade N���ڵ��Ƿ��ڵ��� 0 1 ���� û����סΪ0������סΪ1
load('data/building');  % building�м�¼���ǽ���������������ļнǡ������ﳤ���ߡ����������꣨-1,0��������ڵ�ĺ�������ľ��롢��������̫���߶Ƚ�alpha��̫����λ��beta
shade = [];
%Shade(����������������ļн�theta, l, d, h, a, b, alpha, beta)
shade_temp = Shade(building(1),building(2),building(3),building(4),building(5),building(6),alpha,beta);
shade = shade_temp; % shade����1��ڵ�ÿ���ӱ��ڵ������
%a=find(shade==1)    446---722  7:26-----12:02
%% �������ݣ����ɾ�����Ӱ�����������,data_min2019_nodes                                  
shade_energy = 6.33; 
Datahand(shade,shade_energy);
%% Ԥ��
y_Elman = [];
y_IPro = [];
y_ANN = [];
y_test = [];
load('data/data_min2019_nodes.mat');
data19min_real = reshape(data_nodes, 1440,365);  %��һ����ÿ���ӵĳ����� ������ʽΪ1440*365
for i= predict_start:predict_end    %  ����2��60
    test_idx=i;
    [y_Elman_day,y_ANN_day,y_IPro_day] = Forecast(test_idx,shade);  % 8*24
    y_Elman = [y_Elman y_Elman_day];
    y_ANN = [y_ANN y_ANN_day];
    y_IPro = [y_IPro y_IPro_day];
    
    y_test_day = data19min_real(:, test_idx); % 1440*1 һ���� %�����еĵ�test_idx�У�����test_idx��
    y_test_day = mean(reshape(y_test_day, 60, 24));  %60����*24Сʱ
    y_test = [y_test y_test_day];
end
%% IProԤ�����
MAE_IPro = 0;
for i = 1:length(y_test)  % 1416Сʱ   
    MAE_IPro = MAE_IPro+abs(y_test(i)- y_IPro(i));
end
MAE_IPro = MAE_IPro/(length(y_test));
%% ANNԤ�����
MAE_ANN = 0;
for i = 1:length(y_test)
    MAE_ANN = MAE_ANN+abs(y_test(i)- y_ANN(i));
end
MAE_ANN = MAE_ANN/(length(y_test));
%% KEԤ�����
MAE_KE = 0;
for i = 1:length(y_test)
    MAE_KE = MAE_KE+abs(y_test(i)- y_Elman(i));
end
MAE_KE = MAE_KE/(length(y_test));
%% ����bar����
MAE=[MAE_KE,MAE_ANN,MAE_IPro];
dataT=zeros(3,3);
for i=1:3
    dataT(i,i)=MAE(i);
end
MAE_KE_Vector=dataT(1,:);
MAE_ANN_Vector=dataT(2,:);
MAE_IPro_Vector=dataT(3,:);
%% ��ͼ
f1=figure;
left_color = [0 0 0];
right_color = [0 0 0];
set(f1,'defaultAxesColorOrder',[left_color; right_color]);
grid on
yyaxis('left');
plot(y_test(1:96),'r-','LineWidth',2.5);   %��ʵֵ��1��96�죩
hold on
plot(y_Elman(1:96),'b-','LineWidth',1.2);
hold on
plot(y_ANN(1:96),'-','Color',[0.69,0.19,0.38],'LineWidth',1.2);
hold on
plot(y_IPro(1:96),'-','Color',[1,0.6,0.07],'LineWidth',1.2);
hold on
xlabel('Time(h)','FontSize',18);
ylabel('Solar Irradiance(W/m^2)','FontSize',18);  % ����x���y�������
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