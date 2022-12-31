%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% �L�[�{�[�h��ROS��/cmd_vel��publish
%   ��莞�Ԏw�����x�ňړ����A��~
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
robot_type = 'std';
matlab_pub = rospublisher('/cmd_vel', 'geometry_msgs/Twist');
c = rosmessage(matlab_pub);

while 1
    % ���� (�L�[�{�[�h�w�ߒl�ɏ]����莞�Ԉړ�)
    cmd = input('����R�}���h (w�O d�E a�� z�� q�I��) : ', 's');
    c = key2twist(cmd,c);
    if contains(cmd,["q", "Q"])
        break;
    end
    send(matlab_pub, c);
end

% ��~
c.Linear.X = 0.0;
c.Angular.Z = 0.0;
send(matlab_pub, c);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% �֐�
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
