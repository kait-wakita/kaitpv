%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% �ړI�n�Ɍ������Đi�ށi�������Փ˂͉���j
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
robot_type = 'std';

close all;
figure('Position',[100 500 1024 400]);

% LIDAR�̃T�u�X�N���C�o�ݒ�
laser=rossubscriber('/scan');

% /cmd_vel�̃p�u���b�V���ݒ�
matlab_pub = rospublisher('/cmd_vel', 'geometry_msgs/Twist');
base_frame = 'base_link';
c = rosmessage(matlab_pub);
tftree = rostf;
pause(1);

while 1
    cmd = input('�ړI�n (s�J�n�_ g�I���_ q�I��) : ', 's');
    if contains(cmd,'q')
        break;
    elseif contains(cmd,'g')
        xt=11;  yt=0; theta_t = 180;
    else
        xt=0;  yt=0; theta_t = 0;
    end
    
    n=600;
    for i=1:n
        % �Z���V���O
        scandata = receive(laser,10);
        
        % ���F��
        a = (scandata.AngleMin : scandata.AngleIncrement : scandata.AngleMax)' * 180 / 3.14; % �p�x(deg)
        a = mod(a, 360);
        r = scandata.Ranges; % ����(m)
        r(r==Inf)=scandata.RangeMax; % �f�[�^���Ȃ��ꍇ�͍ő勗���Ƃ���
        dist_c=min(r((a>345)|(a<= 15),:)); % �Ώ۔͈͂̍ŏ�����
        dist_l=min(r((a> 15)&(a<= 45),:)); % �Ώ۔͈͂̍ŏ�����
        dist_r=min(r((a>315)&(a<=345),:)); % �Ώ۔͈͂̍ŏ�����
        
        % ���`��
        subplot(1,2,1);
        plot(scandata);
        xlim([-1 3])
        ylim([-2 2])
        title(sprintf('��:%3.2f ��:%3.2f �E:%3.2f', dist_l, dist_c, dist_r), 'FontSize',14);
        xlabel('X (�ԗ����W�n)');
        ylabel('Y (�ԗ����W�n)');
        hold on;
        plot([10 0 10], [-2.68 0 2.68], '-r');
        plot([0 10], [0 10], '-g');
        plot([0 10], [0 -10], '-g');
        hold off;
        
        % �ʒu���Z�ƕ`��i����odom�A���{�b�gbase_footprint)
        origin2base=getTransform(tftree, 'map', base_frame);
        x=origin2base.Transform.Translation.X;
        y=origin2base.Transform.Translation.Y;
        quat=origin2base.Transform.Rotation;
        eul_d=rad2deg(quat2eul([quat.W quat.X quat.Y quat.Z]));
        theta = eul_d(1);
        
        subplot(1,2,2);
        hold on;
        plot(x,y,'ok');
        xlim([-3 13]);
        ylim([-3 3]);
        title('�I�h���g��','FontSize',14)
        xlabel('X (���[���h���W�n)');
        ylabel('Y (���[���h���W�n)');
        q=quiver(x,y,0.3*cosd(theta),0.3*sind(theta));
        q.MaxHeadSize=1.0;
        view(270,90);
        hold off;
        
        % ��]�������Z
        rt = atan2d(yt-y, xt-x) - theta;
        rt = regulate_degree(rt);
        fprintf("x;%4.1f, y:%4.1f, theta:%4.1f, rt:%4.1f\n", x,y,theta, rt);
        
        % �o�H����
        if(sqrt((xt-x)^2+(yt-y)^2)<0.5)
            if(abs(theta - theta_t)<10)
                text(xt,yt,'�ړI�n����','Color','red','FontSize',18);
                break;
            else
                c.Linear.X = 0.0;
                c.Angular.Z = pi/4;
            end
        else
            c.Linear.X = 1.0;
            c.Angular.Z = 0.0;
            if dist_c < 1.0
                if (dist_r > dist_l)
                    c.Angular.Z = -pi/2;
                else
                    c.Angular.Z = pi/2;
                end
            elseif ((dist_r > 1.0)&&(dist_l > 1.0))
                c.Angular.Z = 1.0*deg2rad(rt);
            elseif (dist_r > dist_l)
                c.Angular.Z = -pi/8;
            else
                c.Angular.Z = pi/8;
            end
            c.Angular.Z = min(max(c.Angular.Z, -pi/2), pi/2);
        end
        
        % ����
        send(matlab_pub, c);
        pause(0.0);
    end
    
    % ��~
    c.Linear.X = 0.0;
    c.Angular.Z = 0.0;
    send(matlab_pub, c);
end


function dr=regulate_degree(d)
dr = mod(d+180,360)-180;
end

