#!/bin/bash

# trap ctrl-c and call ctrl_c()
trap ctrl_c INT

function ctrl_c() {
	echo "Run aborted. Deleting partial results from $TEMP"
	rm -rf $TEMP
	exit 2
}

if [ "$#" -ne 1 ]; then
	echo "Illegal number of parameters. Please specify output directory."
	exit 1
fi

for TAG in `( cd openssl && git tag | grep OpenSSL_1_0_ | grep --invert beta | grep --invert reformat | sort )`
do
	TAGDIR=$1/$TAG
	mkdir $TAGDIR
	TEMP=`mktemp -d`
	echo "Now processing $tag in $TEMP"
	( cd openssl && git checkout-index -a -f --prefix=$TEMP/ )
	( cd $TEMP && ./config > $TAGDIR/config.log )
	( cd $TEMP && nice -n 40 make 2>&1 > $TAGDIR/build.log )
	( cd $TEMP && ./apps/openssl speed 2> $TAGDIR/speed.doing > $TAGDIR/speed.tables )
	rm -rf $TEMP
done
exit 0
