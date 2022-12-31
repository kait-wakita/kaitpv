%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% キーボードでROSの/cmd_velをpublish
%   一定時間指示速度で移動し、停止
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
robot_type = 'std';
matlab_pub = rospublisher('/cmd_vel', 'geometry_msgs/Twist');
c = rosmessage(matlab_pub);

while 1
    % 制御 (キーボード指令値に従い一定時間移動)
    cmd = input('制御コマンド (w前 d右 a左 z後 q終了) : ', 's');
    c = key2twist(cmd,c);
    if contains(cmd,["q", "Q"])
        break;
    end
    send(matlab_pub, c);
end

% 停止
c.Linear.X = 0.0;
c.Angular.Z = 0.0;
send(matlab_pub, c);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 関数
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function c = key2twist(cmd,twist)
std_v=1.0;
std_w=3.14/2;
c = twist;
c.Linear.X = 0.0;
c.Angular.Z = 0.0;
if contains(cmd,'w')
    c.Linear.X = std_v;
end
if contains(cmd,'W')
    c.Linear.X = 2*std_v;
end
if contains(cmd,'z')
    c.Linear.X = -std_v;
end
if contains(cmd,'Z')
    c.Linear.X = -2*std_v;
end
if contains(cmd,'d')
    c.Angular.Z = -std_w;
end
if contains(cmd,'D')
    c.Angular.Z = -2*std_w;
end
if contains(cmd,'a')
    c.Angular.Z = std_w;
end
if contains(cmd,'A')
    c.Angular.Z = 2*std_w;
end
end
