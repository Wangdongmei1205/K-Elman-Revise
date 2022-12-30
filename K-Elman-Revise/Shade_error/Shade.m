% Ҫ������6�����������Ϊһ�����飬����˽ڵ�һ���б��ڵ������
function shade = Shade(theta, l, d, h, a, b, alpha, beta)
shade = [];
if theta == 0
    %tan(�û��ȱ�ʾ�Ľ�) tand(�öȱ�ʾ�Ľ�) a=tan(pi/4) b=tand(45)  a,b=1.0000
    % k1��ʾtand(theta)��k2��ʾcotd(theta)
    k1 = tand(theta);  % ����������������ļн�
    k2 = 1000000000;    
else
    if theta == 90   % 
        k1 = 1000000000;
        k2 = cotd(theta);
    else
        k1 = tand(theta);
        k2 = cotd(theta);
    end
end

for i=1:length(alpha)
    if beta(i)>=0&&beta(i)<=theta || beta(i)>=theta+270&&beta(i)<=360 %���1
        p1 = a*k1+b;
        p2 = k1*(a-h/tand(alpha(i))*sind(beta(i)))+b-h/tand(alpha(i))*cosd(beta(i));
        p3 = (-1)*a*cotd(beta(i))+b;
        p4 = (-1)*cotd(beta(i))*(a+l*cosd(theta))+b-l*sind(theta);
        
        p5 = (-1)*cotd(beta(i))*(a+l*cosd(theta))+b-l*sind(theta);
        p6 = (-1)*cotd(beta(i))*(a+l*cosd(theta)+d*sind(theta))+b-l*sind(theta)+d*cosd(theta);
        p7 = (-1)*k2*(a+l*cosd(theta))+b-l*sind(theta);
        p8 = (-1)*k2*(a+l*cosd(theta)-h/tand(alpha(i))*sind(beta(i)))+b-l*sind(theta)-h/tand(alpha(i))*cosd(beta(i));
        
        flag1 = 0;
        flag2 = 0;
        flag3 = 0;
        flag4 = 0;
        if p1>=0 && 0>=p2 || p2>=0 && 0>=p1
            flag1 = 1;
        end
        
        if p3>=0 && 0>=p4 || p4>=0 && 0>=p3
            flag2 = 1;
        end
        
        if p5>=0 && 0>=p6 || p6>=0 && 0>=p5
            flag3 = 1;
        end
        
        if p7>=0 && 0>=p8 || p8>=0 && 0>=p7
            flag4 = 1;
        end
        
        if flag1==1 && flag2==1 || flag3==1 && flag4==1
            shade(i) = 1;
        else
            shade(i) = 0;
        end
    else
        if beta(i)>=theta&&beta(i)<=theta+90 %���2
            p1 = (-1)*cotd(beta(i))*(a+d*sind(theta))+b+d*cosd(theta);
            p2 = (-1)*a*cotd(beta(i))+b;
            p3 = k2*((-1)*a+h/tand(alpha(i))*sind(beta(i)))+b-h/tand(alpha(i))*cosd(beta(i));
            p4 = (-1)*a*k2+b;
            
            p5 = (-1)*a*cotd(beta(i))+b;
            p6 = (-1)*cotd(beta(i))*(a+l*cosd(theta))+b-l*sind(theta);
            p7 = a*k1+b;
            p8 = k1*(a-h/tand(alpha(i))*sind(beta(i)))+b-h/tand(alpha(i))*cosd(beta(i));
            
            flag1 = 0;
            flag2 = 0;
            flag3 = 0;
            flag4 = 0;
            if p1>=0 && 0>=p2 || p2>=0 && 0>=p1
                flag1 = 1;
            end

            if p3>=0 && 0>=p4 || p4>=0 && 0>=p3
                flag2 = 1;
            end

            if p5>=0 && 0>=p6 || p6>=0 && 0>=p5
                flag3 = 1;
            end

            if p7>=0 && 0>=p8 || p8>=0 && 0>=p7
                flag4 = 1;
            end

            if flag1==1 && flag2==1 || flag3==1 && flag4==1
                shade(i) = 1;
            else
                shade(i) = 0;
            end
        else
            if beta(i)>=theta+90&&beta(i)<=theta+180 %���3
                p1 = cotd(beta(i))*(-a)+b;
                p2 = cotd(beta(i))*(-a-d*sind(theta))+b+d*cosd(theta);
                p3 = k2*(-a-d*sind(theta)+h/tand(alpha(i))*sind(beta(i)))+b+d*cosd(theta)-h/tand(alpha(i))*cosd(beta(i));
                p4 = k2*(-a)+b;
                p5 = -k1*(-a-d*sind(theta)+h/tand(alpha(i))*sind(beta(i)))+b+d*cosd(theta)-h/tand(alpha(i))*cosd(beta(i));
                p6 = -k1*(-a-d*sind(theta))+b+d*cosd(theta);
                p7 = cotd(beta(i))*(-a-d*sind(theta))+b+d*cosd(theta);
                p8 = cotd(beta(i))*(-a-l*cosd(theta)-d*sind(theta))+b-l*sind(theta)+d*cosd(theta);
                
                flag1 = 0;
                flag2 = 0;
                flag3 = 0;
                flag4 = 0;
                if p1>=0 && 0>=p2 || p2>=0 && 0>=p1
                    flag1 = 1;
                end

                if p3>=0 && 0>=p4 || p4>=0 && 0>=p3
                    flag2 = 1;
                end

                if p5>=0 && 0>=p6 || p6>=0 && 0>=p5
                    flag3 = 1;
                end

                if p7>=0 && 0>=p8 || p8>=0 && 0>=p7
                    flag4 = 1;
                end

                if flag1==1 && flag2==1 || flag3==1 && flag4==1
                    shade(i) = 1;
                else
                    shade(i) = 0;
                end
            else %���4
                p1 = cotd(beta(i))*(-a-d*sind(theta))+b+d*cosd(theta);
                p2 = cotd(beta(i))*(-a-l*cosd(theta)-d*sind(theta))+b-l*sind(theta)+d*cosd(theta);
                p3 = -k1*(-a-d*sind(theta)+h/tand(alpha(i))*sind(beta(i)))+b+d*cosd(theta)-h/tand(alpha(i))*cosd(beta(i));
                p4 = -k1*(-a-d*sind(theta))+b+d*cosd(theta);
                p5 = cotd(beta(i))*(-a-l*cosd(theta)-d*sind(theta))+b-l*sind(theta)+d*cosd(theta);
                p6 = cotd(beta(i))*(-a-l*cosd(theta))+b-l*sind(theta);
                p7 = k2*(-a-l*cosd(theta))+b-l*sind(theta);
                p8 = k2*(-a-l*cosd(theta)+h/tand(alpha(i))*sind(beta(i)))+b-l*sind(theta)-h/tand(alpha(i))*cosd(beta(i));
                
                flag1 = 0;
                flag2 = 0;
                flag3 = 0;
                flag4 = 0;
                if p1>=0 && 0>=p2 || p2>=0 && 0>=p1
                    flag1 = 1;
                end

                if p3>=0 && 0>=p4 || p4>=0 && 0>=p3
                    flag2 = 1;
                end

                if p5>=0 && 0>=p6 || p6>=0 && 0>=p5
                    flag3 = 1;
                end

                if p7>=0 && 0>=p8 || p8>=0 && 0>=p7
                    flag4 = 1;
                end

                if flag1==1 && flag2==1 || flag3==1 && flag4==1
                    shade(i) = 1;
                else
                    shade(i) = 0;
                end
            end
        end
    end
end

% �������������ס
for i=1:length(shade)
    if shade(i)==1 && alpha(i)<0
        shade(i) = 0;
    end
end