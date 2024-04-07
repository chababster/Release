#!/bin/bash

ipAddr=$(ifconfig | grep 192 | awk '{print $2}')

if [[ -z ${ipAddr} ]]; then
    echo "NO IP FOUND..."
    exit 1
fi

while true
do
	echo "--- $(date) ---"
	echo "Running speed test on ${ipAddr}..."
	python3 network.py ${ipAddr} > tmp.txt
	echo "Writing out results..."
	date > output.txt
	uname -a >> output.txt
	if [[ ! -z $(cat tmp.txt) ]]; then
		cat tmp.txt >> output.txt
    	fi
	rm tmp.txt
	sleep 300
done
