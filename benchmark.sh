mkdir machine
uname -a > machine/uname
cp /proc/cpuinfo machine/cpuinfo
cp /proc/meminfo machine/meminfo
DIR=`openssl version`
mkdir "$DIR"
cd "$DIR"
sudo nice -n -20 sudo -u `whoami` openssl speed 2>speed.doing > speed.tables


