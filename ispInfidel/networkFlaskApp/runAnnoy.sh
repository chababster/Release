#!/bin/bash
while true
do
	sleep 300
	echo "Annoying..."
	curl localhost:9090 > /dev/null
done
