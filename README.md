# KaitPV
先進研でのロボットテスト用シミュレータ

# DEMO

# Requirement

* ubuntu 18.04
* ros melodic

# Installation

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

# Usage

```bash
roscd kaitpv/plugins/animatedbox
source gazebo_path_set.sh
roslaunch kaitpv kaitpv_with_d2_walk1.launch

```

# Note

# Author

* wakit@cco.kanagawa-it.ac.jp

# License

"kaitpv" is under [MIT license](https://en.wikipedia.org/wiki/MIT_License).
