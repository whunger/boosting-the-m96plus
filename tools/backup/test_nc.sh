#!/bin/bash

adb forward tcp:4444 tcp:4444

echo "boox > local nc uncompressed"
adb shell -n "dd if=/dev/zero bs=1M count=100 | nc -l -p 4444" &
sleep 1
time sh -c "nc -d 127.0.0.1 4444 > /dev/null"
wait

echo "boox > local nc compressed"
adb shell -n "dd if=/dev/zero bs=1M count=100 | gzip -c -1 | nc -l -p 4444" &
sleep 1
time sh -c "nc -d 127.0.0.1 4444 | gzip -c -d > /dev/null"
wait

echo "local > boox nc uncompressed"
adb shell -n "nc -l -p 4444 -w 3 | dd of=/dev/null bs=1M" &
sleep 1
time sh -c "dd if=/dev/zero bs=1M count=100 2> /dev/null | nc 127.0.0.1 4444"
wait

echo "local > boox nc compressed"
adb shell -n "nc -l -p 4444 -w 3 | gzip -c -d | dd of=/dev/null bs=1M" &
sleep 1
time sh -c "dd if=/dev/zero bs=1M count=100 2> /dev/null | gzip -c -1 | nc 127.0.0.1 4444"
wait

adb forward --remove tcp:4444

echo exec-out uncompressed
time sh -c "adb exec-out \"dd if=/dev/zero bs=1M count=100 2> /dev/null\" | dd of=/dev/null bs=1M"

echo exec-out compressed
time sh -c "adb exec-out \"dd if=/dev/zero bs=1M count=100 2> /dev/null | gzip -c -1\" | gzip -c -d | dd of=/dev/null bs=1M"

echo exec-in uncompressed
time sh -c "dd if=/dev/zero bs=1M count=100 | adb exec-in \"dd of=/dev/null bs=1M\""

echo exec-in compressed
time sh -c "dd if=/dev/zero bs=1M count=100 | gzip -c -1 | adb exec-in \"gzip -c -d | dd of=/dev/null bs=1M\""
