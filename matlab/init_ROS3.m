%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ROS�Ƃ̒ʐM�m��
%  WSL�Ή� (2022.1.5)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
rosshutdown;

[rc str]=system('ipconfig | find "IPv4"');

str2=splitlines(str);
str_ip1=extractAfter(str2{1,1}, ':');
str_ip=str_ip1(2:end);
setenv('ROS_IP',str_ip);        % windowsPC�� IP�A�h���X 
setenv('ROS_HOSTNAME',str_ip);  % windowsPC�� IP�A�h���X
            
%rosinit('192.168.1.6');         % ROS�� IP�A�h���X
%rosinit('172.22.0.117');         % ROS�� IP�A�h���X
rosinit('172.17.225.3');         % ROS�� IP�A�h���X (WSL�̏ꍇ����ς��)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ���G���[���o��Ƃ�1 (7�`11�s�ڂŃG���[)
%  1. ������PC(windows)��IP�h���X �𒲂ׂ�
%�@�@ �R�}���h�v�����v�g�Łuipconfig /all�v��ł�IPv4�A�h���X��T��
%  2. �ȉ��̂悤��str_ip��windwos IP�A�h���X�𒼐ڏ���
%        str_ip='192.168.1.XX';
%        setenv('ROS_IP',str_ip);
%        setenv('ROS_HOSTNAME',str_ip);

% ���G���[���o��Ƃ�2 (13�s�ڂŃG���[�j
%  1. ROS����IP�A�h���X�𒲂ׂ�
%�@�@�uip a�v��ł��Ainet 192.168.1.YY �Ȃǂ�T��
%  2. �ȉ��̂悤��IP�A�h���X�𒼐ڏ���
%       rosinit('192.168.1.YY');
