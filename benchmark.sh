#temporarily grab permissions to grab CPU priority
#and relinquish before running rest of benchmark
if [ `whoami` = "root" ]
then
	echo Setting CPU Governor to "performance"
	OLDGOV=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor`
	echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
	export CPUFREQ=`sudo cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq`
	nice -n -20 sudo -u $1 ./benchmark.1.sh
	echo $OLDGOV > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
	echo Restoring CPU Governor to $OLDGOV
else
	sudo $0 `whoami`
fi
