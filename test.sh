#!/bin/sh

i=0
s=${S:-"0.1"}

while :
do
  i=`expr $i + 1`
  echo $i
  sleep $s 
done
