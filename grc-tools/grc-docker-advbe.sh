#!/bin/bash

HOME=/home/leeee

/bin/ps -axfww | /bin/grep -v grep | /bin/grep -q gridcoinresearch; [ ${PIPESTATUS[2]} -ne 0 ] && echo "GridcoinResearchD is gone" && exit 1

grc-docker.sh walletlock
grc-docker.sh walletpassphrase `cat $HOME/.passme.gpg.asc | gpg -d 2> /dev/null` 43200
grc-docker.sh advertisebeacon true
/bin/sleep 15s
grc-docker.sh beaconstatus
/bin/sleep 15s
grc-docker.sh getwalletinfo
grc-docker.sh walletlock
grc-docker.sh walletpassphrase `cat $HOME/.passme.gpg.asc | gpg -d 2> /dev/null` 43200 true

