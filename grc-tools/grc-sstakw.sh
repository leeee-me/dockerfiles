#!/bin/bash

HOME=/home/me

STAKETIME=$1
[ -z "$1" ] && STAKETIME=86400

/bin/ps -axfww | /bin/grep -v grep | /bin/grep -q gridcoinresearch; [ ${PIPESTATUS[2]} -ne 0 ] && echo "GridcoinResearchD is gone" && exit 1

echo ".. lock wallet"
/usr/bin/gridcoinresearchd walletlock || exit 1
echo "... unlock wallet for staking by $STAKETIME secs"
/usr/bin/gridcoinresearchd walletpassphrase `cat $HOME/.passme.gpg.asc | gpg -d 2> /dev/null` $STAKETIME true

echo -n ".... sleep 15s to update" 1>&2 && for i in `seq 15`; do echo -n "." 1>&2; sleep 1s; done && echo 1>&2
echo

echo "=== beacon"
/usr/bin/gridcoinresearchd beaconstatus | /usr/bin/jq -r '.active[] | keys_unsorted[] as $k | "\($k), \(.[$k])"' | grep -e ^cpid -e ^active -e ^address -e ^is_mine

echo "=== mining"
/usr/bin/gridcoinresearchd getmininginfo | /usr/bin/jq -r 'keys_unsorted[] as $k | "\($k), \(.[$k])"' | grep -e ^staking -e ^mining-error 

echo "=== info"
/usr/bin/gridcoinresearchd getinfo | /usr/bin/jq -r 'keys_unsorted[] as $k | "\($k), \(.[$k])"' | grep -e '^connections' -e '^version' -e '^walletversion' -e '^balance'

echo "=== wallet"
/usr/bin/gridcoinresearchd getwalletinfo | /usr/bin/jq -r 'keys_unsorted[] as $k | "\($k), \(.[$k])"' | grep -e '^staking'


echo
echo -n ">> Wallet unlocked until: "
date --date=@`/usr/bin/gridcoinresearchd getinfo | /usr/bin/jq -r '.unlocked_until'`
echo -n ">> Now time is:           "
date --date=now
