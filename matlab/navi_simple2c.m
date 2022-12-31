%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 目的地に向かって進む（ただし衝突は回避）
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
robot_type = 'std';

close all;
figure('Position',[100 500 1024 400]);

% LIDARのサブスクライバ設定
laser=rossubscriber('/scan');

% /cmd_velのパブリッシャ設定
matlab_pub = rospublisher('/cmd_vel', 'geometry_msgs/Twist');
base_frame = 'base_link';
c = rosmessage(matlab_pub);
tftree = rostf;
pause(1);

while 1
    cmd = input('目的地 (s開始点 g終了点 q終了) : ', 's');
    if contains(cmd,'q')
        break;
    elseif contains(cmd,'g')
        xt=11;  yt=0; theta_t = 180;
    else
        xt=0;  yt=0; theta_t = 0;
    end
    
    n=600;
    for i=1:n
        % センシング
        scandata = receive(laser,10);
        
        % 環境認識
        a = (scandata.AngleMin : scandata.AngleIncrement : scandata.AngleMax)' * 180 / 3.14; % 角度(deg)
        a = mod(a, 360);
        r = scandata.Ranges; % 距離(m)
        r(r==Inf)=scandata.RangeMax; % データがない場合は最大距離とする
        dist_c=min(r((a>345)|(a<= 15),:)); % 対象範囲の最小距離
        dist_l=min(r((a> 15)&(a<= 45),:)); % 対象範囲の最小距離
        dist_r=min(r((a>315)&(a<=345),:)); % 対象範囲の最小距離
        
        % 環境描画
        subplot(1,2,1);
        plot(scandata);
        xlim([-1 3])
        ylim([-2 2])
        title(sprintf('左:%3.2f 中:%3.2f 右:%3.2f', dist_l, dist_c, dist_r), 'FontSize',14);
        xlabel('X (車両座標系)');
        ylabel('Y (車両座標系)');
        hold on;
        plot([10 0 10], [-2.68 0 2.68], '-r');
        plot([0 10], [0 10], '-g');
        plot([0 10], [0 -10], '-g');
        hold off;
        
        % 位置演算と描画（初期odom、ロボットbase_footprint)
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
        title('オドメトリ','FontSize',14)
        xlabel('X (ワールド座標系)');
        ylabel('Y (ワールド座標系)');
        q=quiver(x,y,0.3*cosd(theta),0.3*sind(theta));
        q.MaxHeadSize=1.0;
        view(270,90);
        hold off;
        
        % 回転方向演算
        rt = atan2d(yt-y, xt-x) - theta;
        rt = regulate_degree(rt);
        fprintf("x;%4.1f, y:%4.1f, theta:%4.1f, rt:%4.1f\n", x,y,theta, rt);
        
        % 経路生成
        if(sqrt((xt-x)^2+(yt-y)^2)<0.5)
            if(abs(theta - theta_t)<10)
                text(xt,yt,'目的地到着','Color','red','FontSize',18);
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
        
        % 制御
        send(matlab_pub, c);
        pause(0.0);
    end
    
    % 停止
    c.Linear.X = 0.0;
    c.Angular.Z = 0.0;
    send(matlab_pub, c);
end


function dr=regulate_degree(d)
dr = mod(d+180,360)-180;
end

