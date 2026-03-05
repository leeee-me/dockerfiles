#!/bin/bash

HOME=/home/leeee

STAKETIME=$1
[ -z "$1" ] && STAKETIME=86400

/bin/ps -axfww | /bin/grep -v grep | /bin/grep -q gridcoinresearch; [ ${PIPESTATUS[2]} -ne 0 ] && echo "GridcoinResearchD is gone" && exit 1

[ ! -z "$2" ] && echo ".. lock wallet"
/usr/bin/gridcoinresearchd walletlock || exit 1
[ ! -z "$2" ] && echo "... unlock wallet for staking by $STAKETIME secs"
/usr/bin/gridcoinresearchd walletpassphrase `cat $HOME/.passme.gpg.asc | gpg -d 2> /dev/null` $STAKETIME true || exit 1

[ ! -z "$2" ] && echo -n ".... sleep 15s to update" 1>&2
[ ! -z "$2" ] && for i in `seq 15`; do echo -n "." 1>&2; sleep 1s; done && echo 1>&2
[ ! -z "$2" ] && echo

[ ! -z "$2" ] && echo "=== beacon"
[ ! -z "$2" ] && /usr/bin/gridcoinresearchd beaconstatus | /usr/bin/jq -r '.active[] | keys_unsorted[] as $k | "\($k), \(.[$k])"' | grep -e ^cpid -e ^active -e ^address -e ^is_mine

[ ! -z "$2" ] && echo "=== mining"
[ ! -z "$2" ] && /usr/bin/gridcoinresearchd getmininginfo | /usr/bin/jq -r 'keys_unsorted[] as $k | "\($k), \(.[$k])"' | grep -e ^staking -e ^mining-error  -e ^BoincRewardPending -e ^researcher_status

[ ! -z "$2" ] && echo "=== info"
[ ! -z "$2" ] && /usr/bin/gridcoinresearchd getinfo | /usr/bin/jq -r 'keys_unsorted[] as $k | "\($k), \(.[$k])"' | grep -e '^connections' -e '^version' -e '^walletversion' -e '^balance'

[ ! -z "$2" ] && echo "=== wallet"
[ ! -z "$2" ] && /usr/bin/gridcoinresearchd getwalletinfo | /usr/bin/jq -r 'keys_unsorted[] as $k | "\($k), \(.[$k])"' | grep -e '^staking'


[ ! -z "$2" ] && echo
[ ! -z "$2" ] && echo -n "## Wallet unlocked until: " && date --date=@`/usr/bin/gridcoinresearchd getinfo | /usr/bin/jq -r '.unlocked_until'`
[ ! -z "$2" ] && echo -n "## Now time is:           " && date --date=now

exit 0
