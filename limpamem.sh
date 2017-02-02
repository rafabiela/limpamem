#!/bin/sh

PATH="/bin:/usr/bin:/usr/local/bin"
 
# Porcentagem maxima (mude se vc achar q deve) eu deixo em 80%
percent=80
 
# Total da memoria:
ramtotal=`grep -F "MemTotal:" < /proc/meminfo | awk '{print $2}'`

# Memoria livre:
ramlivre=`grep -F "MemFree:" < /proc/meminfo | awk '{print $2}'`
 
# RAM utilizada pelo sistema:
ramusada=`expr $ramtotal - $ramlivre`
 
# Porcentagem de RAM utilizada pelo sistema:
putil=`expr $ramusada \* 100 / $ramtotal`
 
echo =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
date
echo
echo "Mem. utilizada: $putil %";
 
if [ $putil -gt $percent ]
then
date=`date`
echo $date >> /var/log/memoria.log
echo "Mem. utilizada: $putil %" >> /var/log/memoria.log
 
echo "Memoria acima de $percent %, cache foi limpado!";
sync
# 'Dropando' cache:
echo 3 > /proc/sys/vm/drop_caches
# Caso nao esteja utilizanod debian, descomente a linha abaixo
# sysctl -w vm.drop_caches=3 
echo
free -m
echo
echo =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
else
echo "Cache nao foi limpado!";
echo =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
unset percent ramtotal ramlivre ramusada putil
exit $?
fi
