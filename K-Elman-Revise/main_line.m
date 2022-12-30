clear    %���Workspace�ָ����͵����ݣ�ʹ�����������֮�䲻���ͻ
warning off
load('./data/data19min');
data19min(find(data19min < 0)) = 0; %�����б�
%% Ԥ��
y_Elman = [];
y_IPro = [];
y_ANN = [];
y_test = [];
for i =2:60  
    %����������24��СʱԤ��ֵ 1*24
    test_idx=i;
    y_IPro_day = IPro(test_idx);  %Ԥ�⵱ǰʱ�̣�ȡԤ��ʱ��֮ǰ������Сʱ�ĳ��ܣ���18��������ѡ�������������������նȣ���������Ԥ��Ԥ��ʱ��
    y_ANN_day  = ANN(test_idx)';  % 
    y_Elman_day = Elman(test_idx);                                                                                                                                                                             

    y_IPro_day(find(y_IPro_day < 0)) = 0;
    y_ANN_day(find(y_ANN_day < 0)) = 0;
    y_Elman_day(find(y_Elman_day < 0)) = 0;
    
    y_Elman = [y_Elman y_Elman_day];
    y_ANN = [y_ANN y_ANN_day];
    y_IPro = [y_IPro y_IPro_day];
   
    %% ��ʵ����
    %��test_idx���ÿ���ӵ�̫�����ն�1440*1
    y_test_day = data19min(:, test_idx);  % Ԥ�⵱��ÿ���ӵ�̫�����ն�
     %reshape������y_test_day��Ԫ�ط��ص�һ��60*24�ľ���,  �У�Сʱ  �У�����                                                                                                                                                                                                                      
    y_test_day = mean(reshape(y_test_day, 60, 24)); %mean��ֵ1*24 �У�����ÿСʱ��̫�����վ�ֵ
    y_test = [y_test y_test_day]; %����������ϲ���1*24 �����i��ÿСʱ��̫�����վ�ֵ  %����i��ȡֵ������
end
%% IProԤ�����
%y_test����ʵ��ƽ��̫�����վ�ֵ��y_IProΪIpro�㷨�����
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
ylabel('Solar Irradiance(W/m^2)','FontSize',18);  % ����x���y�������
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





