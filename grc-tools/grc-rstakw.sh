#!/bin/bash

/bin/ps -axfww | /bin/grep -v grep | /bin/grep -q gridcoinresearch; [ ${PIPESTATUS[2]} -ne 0 ] && echo "GridcoinResearchD is gone" && exit 1

A=`/usr/bin/gridcoinresearchd getwalletinfo | /usr/bin/jq -r 'keys_unsorted[] as $k | "\($k), \(.[$k])"' | grep -e '^staking'`

grep "true" <<< $A > /dev/null && { [ -z "$1" ] && exit 0; } 
grep "false" <<< $A > /dev/null && { [ -z "$1" ] && exit 1; } 

echo "=== beacon"
/usr/bin/gridcoinresearchd beaconstatus | /usr/bin/jq -r '.active[] | keys_unsorted[] as $k | "\($k), \(.[$k])"' | grep -e ^cpid -e ^active -e ^is_mine
echo "=== mining"
/usr/bin/gridcoinresearchd getmininginfo | /usr/bin/jq -r 'keys_unsorted[] as $k | "\($k), \(.[$k])"' | grep -e ^staking -e ^mining-error -e ^time-to-stake_days -e ^BoincRewardPending 

B=`/usr/bin/gridcoinresearchd getmininginfo | /usr/bin/jq -r 'keys[] as $k | "\($k), \(.[$k])" | select($k=="side-staking")'  | cut -d' ' -f2 | jq -r 'keys[] as $k | "\($k), \(.[$k])" | select($k=="side-staking-enabled")'`
A=`echo $B | cut -d' ' -f2`
[ "$A" == "true" ] && echo $B && /usr/bin/gridcoinresearchd getmininginfo | /usr/bin/jq -r 'keys[] as $k | "\($k), \(.[$k])" | select($k=="side-staking")' | cut -d' ' -f2 | /usr/bin/jq -r 'keys[] as $k | "\($k), \(.[$k])" | select($k=="side-staking-allocations")' | cut -d' ' -f2 | /usr/bin/jq -r '.[] | keys[] as $k | " { \($k), \(.[$k]) }"'

echo "=== info"
/usr/bin/gridcoinresearchd getinfo | /usr/bin/jq -r 'keys_unsorted[] as $k | "\($k), \(.[$k])"' | grep -e '^connections' -e '^version' -e '^walletversion' -e '^balance'
echo "=== wallet"
/usr/bin/gridcoinresearchd getwalletinfo | /usr/bin/jq -r 'keys_unsorted[] as $k | "\($k), \(.[$k])"' | grep -e '^staking'

echo
echo -n "Wallet unlocked until: "
date --date=@`/usr/bin/gridcoinresearchd getinfo | /usr/bin/jq -r '.unlocked_until'`
echo -n "Now time is:           "
date --date=now

