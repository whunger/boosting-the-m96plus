#!/bin/bash

help() {
   bn=`basename $0`
   echo Usage: $bn device partition
}

case $# in
1)
 if [ "$1" == "-h" ]
 then
    help;
 else
    echo wrong parameter
    help
 fi
 echo;;
2)
  mkdir -p /tmp/data
  mount $2 /tmp/data
  amount=$(df -k | grep $2 | awk '{print $2}')
  if [ -z $amount ]
  then
    echo wrong parameters, the device does not exist
    exit
  fi
  stag=$amount
  sleep 1
  umount $2
  rm -fr /tmp/data
  stag=$((stag-32))
  kilo=K
  echo Get disk block size ${amount}${kilo}
  amountkilo=$stag$kilo
  echo Resize to ${stag}${kilo}
  e2fsck -f $2
  resize2fs $2 $amountkilo;;
*)
  echo wrong number of parameters
  help;;
esac
