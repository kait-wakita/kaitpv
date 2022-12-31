%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ROSとの通信確立
%  WSL対応 (2022.1.5)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
rosshutdown;

[rc str]=system('ipconfig | find "IPv4"');

str2=splitlines(str);
str_ip1=extractAfter(str2{1,1}, ':');
str_ip=str_ip1(2:end);
setenv('ROS_IP',str_ip);        % windowsPC側 IPアドレス 
setenv('ROS_HOSTNAME',str_ip);  % windowsPC側 IPアドレス
            
%rosinit('192.168.1.6');         % ROS側 IPアドレス
%rosinit('172.22.0.117');         % ROS側 IPアドレス
rosinit('172.17.225.3');         % ROS側 IPアドレス (WSLの場合毎回変わる)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ★エラーが出るとき1 (7～11行目でエラー)
%  1. 自分のPC(windows)のIPドレス を調べる
%　　 コマンドプロンプトで「ipconfig /all」を打ちIPv4アドレスを探す
%  2. 以下のようにstr_ipにwindwos IPアドレスを直接書く
%        str_ip='192.168.1.XX';
%        setenv('ROS_IP',str_ip);
%        setenv('ROS_HOSTNAME',str_ip);

% ★エラーが出るとき2 (13行目でエラー）
%  1. ROS側のIPアドレスを調べる
%　　「ip a」を打ち、inet 192.168.1.YY などを探す
%  2. 以下のようにIPアドレスを直接書く
%       rosinit('192.168.1.YY');
