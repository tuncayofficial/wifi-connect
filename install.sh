echo Wi-Fi Connect proqramına xoş gəlmişsiniz! Proqramın bütün nüsxələri və hüquqları @tuncayofficial-a aiddir.
sleep 2
echo Wi-Fi Connect yüklənsin? Y/n
read A
echo $A basıldı.
sleep 1
echo IWCTL yüklənir..

chars="/-\|"

while :; do
  for (( i=0; i<${#chars}; i++ )); do
    sleep 0.5
    echo -en "${chars:$i:1}" "\r"
  done
done

sleep 3.5
echo IWCTL yükləndi! Komanda sətrinə IWCTL yazaraq proqramı başladın!
