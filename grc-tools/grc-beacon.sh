#!/bin/bash

/bin/ps -axfww | /bin/grep -v grep | /bin/grep -q gridcoinresearch; [ ${PIPESTATUS[2]} -ne 0 ] && echo "GridcoinResearchD is gone" && exit 1

B=`/usr/bin/gridcoinresearchd getmininginfo | jq -r '.CPID'`

echo "=== Reported beacon in network"
C=`/usr/bin/gridcoinresearchd beaconreport | /usr/bin/jq ".[] | select(.cpid==\"$B\")"`
echo $C | jq -r 'keys_unsorted[] as $k | "\($k), \(.[$k])"' | grep -e ^cpid -e ^address -e ^status

echo
echo "=== Active beacon (be aware of flags) ==="
/usr/bin/gridcoinresearchd beaconstatus | jq -r '.active[] | keys_unsorted[] as $k | "\($k), \(.[$k])"' | grep -e ^active -e ^expired -e ^is_minei -e ^verification_code  -e ^timestamp -e ^address

echo
echo "=== Pending beacon (be aware of flags) ==="
/usr/bin/gridcoinresearchd beaconstatus | jq -r '.pending[] | keys_unsorted[] as $k | "\($k), \(.[$k])"' | grep -e ^active -e ^expired -e ^is_minei -e ^verification_code -e ^timestamp -e ^address

A=`/usr/bin/gridcoinresearchd beaconreport | /usr/bin/jq ".[] | select(.cpid==\"$B\") | .timestamp"`
d1=$A
d2=`date -d now +%s --utc`
echo
echo "==="
echo -n "Gridcoin active beacon live in network for" $(( (d2 - d1) / 86400 )) "days since:  "
date --date="@$A" --utc --rfc-3339=date
