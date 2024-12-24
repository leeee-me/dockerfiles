#!/bin/bash

HOME=/home/me

/bin/ps -axfww | /bin/grep -v grep | /bin/grep -q gridcoinresearch; [ ${PIPESTATUS[2]} -ne 0 ] && echo "GridcoinResearchD is gone" && exit 1

/usr/bin/gridcoinresearchd walletlock
/usr/bin/gridcoinresearchd walletpassphrase `cat $HOME/.passme.gpg.asc | gpg -d 2> /dev/null` 43200
/usr/bin/gridcoinresearchd advertisebeacon true
/bin/sleep 15s
/usr/bin/gridcoinresearchd beaconstatus
/bin/sleep 15s
/usr/bin/gridcoinresearchd getwalletinfo
/usr/bin/gridcoinresearchd walletlock
/usr/bin/gridcoinresearchd walletpassphrase `cat $HOME/.passme.gpg.asc | gpg -d 2> /dev/null` 43200 true

