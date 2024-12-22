#!/bin/bash

HOME=/home/me

function asn {
        WHOAMIA=whois.cymru.com
        whois -h $WHOAMIA "-v $1" | grep -v ^Warn
}

function bulkasn {
        WHOAMIA=whois.cymru.com
        netcat $WHOAMIA 43 | grep -v ^Bulk
}

/bin/ps -axfww | /bin/grep -v grep | /bin/grep -q gridcoinresearch; [ ${PIPESTATUS[2]} -ne 0 ] && echo "GridcoinResearchD is gone" && exit 1

nc -z -w 3 1.1.1.1 53 || nc -z -w 3 8.8.8.8 53 || (echo "Network is Down" && exit 1)

TT=0

echo
# == external IP address ==
C=`curl -m 1 -s4 https://ifconfig.co`
[ -z "$C" ] && C="127.0.0.1"
C=`asn $C | head -n 1`

# == established Gridcoin connections ==
A=`netstat -aunt4 | grep -e ":32749 " | grep ESTAB | cut -c45- | cut -d':' -f1 | sed 's/^[ ]*//' | sort -n | uniq`
AC=`echo $A | tr ' ' '\n' | wc -l`
[ -z "$A" ] && AC=0
[ ! -z "$A" ] && echo ". $C" | cut -c 1,12-31,53-58,82-
B=`IFS=$'\n'; (echo "begin"; echo "verbose"; for i in $A; do echo $i; done; echo "end") | bulkasn | sort -k 7,7 -k 3,3`
IFS=$'\n'; for i in $B; do echo "$ "$i; done | cut -c 1,12-31,53-58,82-
TT=$((TT + AC))

# == established Gridcoin connections ==
A=`netstat -aunt4 | grep -e ":32749 " | grep ESTAB | cut -c45- | cut -d':' -f1 | sed 's/^[ ]*//' | sort -n | uniq`
AC=`echo $A | tr ' ' '\n' | wc -l`
[ -z "$A" ] && AC=0
B=`IFS=$'\n'; (echo "begin"; echo "verbose"; for i in $A; do echo $i; done; echo "end") | bulkasn`
IFS=$'\n'; L=`for i in $B; do echo "$ "$i; done | awk '{print $8}' | sort | uniq | paste -sd',' - | sed -e 's/|/??/'`
echo "$ GRC: $L (#:$AC)"

source $HOME/.bin/ccTLD2

IFS=$'\n'; L=`for i in $B; do echo "$ "$i; done | awk '{print $8}' | sort | uniq`
IFS=$'\n'; M=`for i in $L; do [ -z ${ccTLD[$i]} ] && echo "[??]"; [ ! -z  ${ccTLD[$i]} ] && echo ${ccTLD[$i]}; done | paste -sd',' -` 
echo "$ GRC: $M"

echo
# == external IPv6 address ==
C=`curl -m 1 -s6 https://ifconfig.co`
[ -z "$C" ] && C="::1"
C=`asn $C | head -n 1` 

# == established Gridcoin connections ==
A=`netstat -aunWt6  | grep -e ":32749 " | grep ESTAB | sed -e 's/^[^ ]\+[ ]\+[^ ]\+[ ]\+[^ ]\+[ ]\+[^ ]\+[ ]\+//g' | cut -d' ' -f1 | sed -e 's/:[0-9]\+$//g' | sort -n | uniq`
AC=`echo $A | tr ' ' '\n' | wc -l`
[ -z "$A" ] && AC=0
[ ! -z "$A" ] && echo ". $C" | cut -c 1,12-55,77-82,106-
B=`IFS=$'\n'; (echo "begin"; echo "verbose"; for i in $A; do echo $i; done; echo "end") | bulkasn | sort -k 7,7 -k 3,3`
IFS=$'\n'; for i in $B; do echo "$ "$i; done | cut -c 1,12-55,77-82,106-
TT=$((TT + AC))

# == established Gridcoin connections ==
A=`netstat -aunWt6  | grep -e ":32749 " | grep ESTAB | sed -e 's/^[^ ]\+[ ]\+[^ ]\+[ ]\+[^ ]\+[ ]\+[^ ]\+[ ]\+//g' | cut -d' ' -f1 | sed -e 's/:[0-9]\+$//g' | sort -n | uniq`
AC=`echo $A | tr ' ' '\n' | wc -l`
[ -z "$A" ] && AC=0
B=`IFS=$'\n'; (echo "begin"; echo "verbose"; for i in $A; do echo $i; done; echo "end") | bulkasn`
IFS=$'\n'; L=`for i in $B; do echo "$ "$i; done | awk '{print $8}' | sort | uniq | paste -sd',' - | sed -e 's/|/??/'`
echo "$ GRC: $L (#:$AC)"

if [ "x$AC" != "x0" ]; then
IFS=$'\n'; L=`for i in $B; do echo "$ "$i; done | awk '{print $8}' | sort | uniq`
IFS=$'\n'; M=`for i in $L; do [ -z ${ccTLD[$i]} ] && echo "[??]"; [ ! -z  ${ccTLD[$i]} ] && echo ${ccTLD[$i]}; done | paste -sd',' -` 
echo "$ GRC: $M"
fi


echo
echo "Total peer: "$TT
