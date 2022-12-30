function  [y_Elman_day_shade,y_ANN_day,y_Ipro_day] = Forecast(test_idx,shade)
shade_energy=6.33;
%�����㷨�����test_idx����ĳ�����
y_Elman_day =Elman(test_idx);
y_ANN_day =ANN(test_idx)'; 
y_Ipro_day=Ipro(test_idx); 

y_Elman_day(find(y_Elman_day < 0)) = 0;  
y_ANN_day(find(y_ANN_day < 0)) = 0;
y_Ipro_day(find(y_Ipro_day < 0)) = 0;
%% ��y_Elman�����ݽ�����Ӱ���� 2881~4320
for j=1:24
    shade_min=length(find(ceil((find(shade( (test_idx)*1440-1439:(test_idx)*1440 ) ==1 ))/60)==j));
    y_Elman_day_shade(j) =(y_Elman_day(j)/60)*(60-shade_min)+shade_energy*(shade_min/60);
end
%% ������Ӱ����
% for i =1:N
%     for j=1:24
%         shade_min=length(find(ceil((find(shade(i,(test_idx)*1440-1439:(test_idx)*1440)==1))/60)==j));  % ��Сʱ���ڵ��ķ�����
%         y_Icc_shade(i,j) =( y_Icc(i,j)/60)*(60-shade_min)+shade_energy*(shade_min/60);
%     end
% end
% for i =1:N
%     for j=1:24
%         shade_min=length(find(ceil((find(shade(i,(test_idx)*1440-1439:(test_idx)*1440)==1))/60)==j));  % ��Сʱ���ڵ��ķ�����
%         y_Ipro_shade(i,j) =(y_Ipro(i,j)/60)*(60-shade_min)+shade_energy*(shade_min/60);
%     end
% end
