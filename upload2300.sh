#!/bin/sh

self=`readlink -f "$0"`
scriptname=`basename "$self"`
scriptdir=${self%$scriptname}

. $scriptdir/config
. $nlogrotatepath/redirectlog.src.sh

if [ "$1" = "quiet" ]; then
	quietmode=1
	redirectlog
fi

if [ $uploadurl = "" ]; then
	echo "no uploadurl given, see config-example"
	checklogsize
	exit 1
fi

curlparams=
numreadparams=0

while read line; do
	param1=`echo $line | cut -d' ' -f1`
	param2=`echo $line | cut -d' ' -f2`

	if [ $param1 = "Ti" ]; then
		curlparams="$curlparams -F \"temp-in=$param2\"*"
		numreadparams=$((numreadparams + 1))
	fi
	if [ $param1 = "To" ]; then
		curlparams="$curlparams -F \"temp-out=$param2\"*"
		numreadparams=$((numreadparams + 1))
	fi
	if [ $param1 = "RHi" ]; then
		curlparams="$curlparams -F \"hum-in=$param2\"*"
		numreadparams=$((numreadparams + 1))
	fi
	if [ $param1 = "RHo" ]; then
		curlparams="$curlparams -F \"hum-out=$param2\"*"
		numreadparams=$((numreadparams + 1))
	fi
	if [ $param1 = "RP" ]; then
		curlparams="$curlparams -F \"pres=$param2\"*"
		numreadparams=$((numreadparams + 1))
	fi
	if [ $param1 = "DP" ]; then
		curlparams="$curlparams -F \"dewpoint=$param2\"*"
		numreadparams=$((numreadparams + 1))
	fi
	if [ $param1 = "Rtot" ]; then
		curlparams="$curlparams -F \"rain=$param2\"*"
		numreadparams=$((numreadparams + 1))
	fi
	if [ $param1 = "WS" ]; then
		curlparams="$curlparams -F \"windspeed=$param2\"*"
		numreadparams=$((numreadparams + 1))
	fi
	if [ $param1 = "DIRtext" ]; then
		curlparams="$curlparams -F \"winddir=$param2\"*"
		numreadparams=$((numreadparams + 1))
	fi
done

if [ $numreadparams -le 1 ]; then
	echo "error: not enough read params"
	checklogsize
	exit 1
fi

curlparams="$curlparams -F \"date=`date +%s`\"*"
curlparams="$curlparams \"$uploadurl\""

# Replacing * chars with null chars for xarg
curlparams=`echo $curlparams | tr '*' '\0'`

result=`echo $curlparams | xargs curl -s 2>/dev/null`

if [ "$result" != "ok" ]; then
	echo "upload error: $result"
else
	echo "upload ok"
fi

checklogsize
