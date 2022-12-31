# KaitPV
先進研でのロボットテスト用GazeboシミュレータとMATLAB経路生成
* 障害物は静止と移動
* amclでの自己位置推定
* MATLABのサンプル経路生成プログラム


![動作例](images/kaitpv_gazebo.png)![動作例](images/kaitpv_rviz.png)

# 動作条件

* ubuntu 18.04
* ros melodic

# インストール

```bash
cd ~/catkin_ws/src
git clone https://github.com/kait-wakita/kaitpv.git
cd plugins/animatedbox
rm -rf build
mkdir build
cd build
cmake ..
make
```

# 使用方法(Gazebo)

静止物シミュレーション
```bash
roslaunch kaitpv kaitpv_with_d2_stay1.launch
```

移動物シミュレーション (source gazebo_path_set.shは一度実行すれば良い)
```bash
roscd kaitpv/plugins/animatedbox
source gazebo_path_set.sh
roslaunch kaitpv kaitpv_with_d2_walk1.launch
```

# 使用方法(MATLAB)
* init_ROS.m: ROSとの通信設定、wslのipアドレスは毎回変わるので設定
* keycntl.m: キーコマンドでロボットを操作
* simple_navi.m: 出発地と目的地の移動、静止障害物は回避可能

# Note
* 2022.12.31 最初のバージョン

# Author

* wakit@cco.kanagawa-it.ac.jp

# License

"kaitpv" is under [MIT license](https://en.wikipedia.org/wiki/MIT_License).
