#!/bin/bash

HOME=/home/leeee

/bin/ps -axfww | /bin/grep -v grep | /bin/grep -q gridcoinresearch; [ ${PIPESTATUS[2]} -ne 0 ] && echo "GridcoinResearchD is gone" && exit 1

grc-docker.sh walletlock || { echo "walletlock failed"; exit 1; }
grc-docker.sh walletpassphrase `cat $HOME/.passme.gpg.asc | gpg -d 2> /dev/null` 43200 || { echo "walletpassphrase failed"; exit 1; }
grc-docker.sh backupprivatekeys || { echo "backupprivatekeys failed"; exit 1; }
grc-docker.sh backupwallet || { echo "backupwallet failed"; exit 1; }
grc-docker.sh walletlock || { echo "walletlock failed"; exit 1; }
grc-docker.sh walletpassphrase `cat $HOME/.passme.gpg.asc | gpg -d 2> /dev/null` 43200 true || { echo "walletpassphrase failed"; exit 1; }

exit 0
