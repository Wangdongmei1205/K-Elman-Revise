function y_head = Ipro(idx)
%% ����19��ÿ���ӵ�����
load('data/data19min');  % 525600*1  
data19min(find(data19min < 0)) = 0;
data19min = reshape(data19min, 1, size(data19min, 1)*size(data19min, 2));  % ��2019��ÿ�������(1440*365)->(1*(1440*365)) һ����1440����
data19 = mean(reshape(data19min, 60, 8760));  % ��2019��ÿ�������(1440*365)->(60*8760)  8760����һ���Сʱ�������ֵǰÿ�б�ʾһСʱ�У�ÿ���ӵķ��ն�
data19hour = reshape(data19, 24, 365);  % dataΪ1*8760��ÿ�б�ʾÿ��ÿСʱ�ķ��վ�ֵ��24*365
%% ����18��ÿ���ӵ�����
load('data/data18min');  % 525600*1  
data18min(find(data18min < 0)) = 0;
data18min = reshape(data18min, 1, size(data18min, 1)*size(data18min, 2)); 
data18 = mean(reshape(data18min, 60, 8760)); 
data18hour = reshape(data18, 24, 365); 

y_head = [];
for current_time = 1:24
    if current_time == 1
        Ca = data19hour(24, idx-1);  %19��Ԥ��ǰһ��24��
        Cb = data19hour(23, idx-1);  %19��Ԥ��ǰһ��23��
    else
        if current_time == 2
            Ca = data19hour(1, idx);  %19���2��1��
            Cb = data19hour(24, idx-1);  %19���һ��24��
        else
            Ca = data19hour(current_time - 1, idx);%19���2��Ԥ��ǰ1��
            Cb = data19hour(current_time - 2, idx);%19���2��Ԥ��ǰ2��
        end
    end %����Ԥ��ʱ��֮ǰ������Сʱ�ĳ���

    sim_a = -1;
    sim_b = -1; %��¼�����Ƶ�����������
    mae_a = inf;
    mae_b = inf; %��¼mae����Сֵ�ʹ�Сֵ
    for i = 2:365 %��18��һ������ѡ���������Ƶ�
        if current_time == 1 %1��ǰΪ23 24
            Xa = data18hour(24, i-1); %18��1~364���24��23��ĳ���   Xa����Ԥ��ǰ1��Сʱ�ĳ���
            Xb = data18hour(23, i-1);%Xb����Ԥ��ǰ2��Сʱ�ĳ���
        else
            if current_time == 2   %2��ǰΪ24 1
                Xa = data18hour(1, i);%2��365���1��
                Xb = data18hour(24, i-1); %1~364���24��
            else %����Ϊ
                Xa = data18hour(current_time - 1, i);
                Xb = data18hour(current_time - 2, i);
            end
        end
        mae = abs(Ca-Xa)/2 + abs(Cb-Xb)/2;
        if mae < mae_b
            if mae < mae_a
                mae_b = mae_a;
                sim_b = sim_a;
                mae_a = mae;
                sim_a = i;
            else
                mae_b = mae;
                sim_b = i;
            end
        end
    end
    %ѡ������������շֱ�Ϊsim_a��sim_b
    %��Ӧ��mae�ֱ�Ϊmae_a��mae_b
    if mae_a+mae_b ~= 0
        w_a = 1-mae_a/(mae_a+mae_b);
        w_b = 1-mae_b/(mae_a+mae_b);
    else
        w_a = 1;
        w_b = 1;
    end
    %���������յĶ�Ӧʱ��εķ���ǿ��
    O_a = data18hour(current_time, sim_a);
    O_b = data18hour(current_time, sim_b);
    WP = w_a*O_a + w_b*O_b;
    if Ca+Cb ~= 0
        Sx = 0.5*((Ca-Cb)*2/(Ca+Cb))*Cb;
    else
        Sx = 0;
    end
    pre = 0.7*Ca + 0.3*WP + Sx; % Ԥ��ֵ
    if pre < 0
        pre = 0;
    end
    y_head = [y_head, pre];
    data(current_time, idx) = pre;
end