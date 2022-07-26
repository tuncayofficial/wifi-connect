#!/usr/bin/env bash

SECONDS=0
secs=10
clear
echo Wi-Fi Connect proqramına xoş gəlmişsiniz! Proqramın bütün nüsxələri və hüquqları @tuncayofficial-a aiddir.
sleep 2
echo Wi-Fi Connect yüklənsin? Y/n
read A
echo $A basıldı.
sleep 1
echo IWCTL yüklənir..

chars="/-\|"

while (( SECONDS < secs )); do
  for (( i=0; i<${#chars}; i++ )); do
    sleep 0.5
    echo -en "${chars:$i:1}" "\r"
  done
done
echo IWCTL yükləndi! Komanda sətrinə iwctl yazaraq proqramı başladın!
