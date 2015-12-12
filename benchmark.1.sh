#make a unique directory per suite run
OUTPUT_DIR="tests/`./uuid.sh`"
MACHINE_DIR=$OUTPUT_DIR/machine
RESULT_DIR=$OUTPUT_DIR/results
echo "Logging results in $OUTPUT_DIR"
mkdir -p $MACHINE_DIR
mkdir -p $RESULT_DIR

#capture some machine information
uname -a > $MACHINE_DIR/uname
cat /proc/cpuinfo > $MACHINE_DIR/cpuinfo
cat /proc/meminfo > $MACHINE_DIR/meminfo
lscpu > $MACHINE_DIR/lscpu
CPU=`grep "model name" /proc/cpuinfo | head -n 1 | cut -d : -f 2`
echo $CPU > $MACHINE_DIR/cpu
echo $CPUFREQ > $MACHINE_DIR/cpuinfo_cur_freq

./benchmark.2.sh `realpath $RESULT_DIR`
if [ $? -eq 0 ]
	then
	git add $RESULT_DIR
	git commit -m"Benchmarked $CPU"
else
	echo "An error ocurred while benchmarking"
fi

