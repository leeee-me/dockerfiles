#!/bin/bash

HOME=/home/me

/bin/ps -axfww | /bin/grep -v grep | /bin/grep -q gridcoinresearch; [ ${PIPESTATUS[2]} -ne 0 ] && echo "GridcoinResearchD is gone" && exit 1

/usr/bin/gridcoinresearchd walletlock || { echo "walletlock failed"; exit 1; }
/usr/bin/gridcoinresearchd walletpassphrase `cat $HOME/.passme.gpg.asc | gpg -d 2> /dev/null` 43200 || { echo "walletpassphrase failed"; exit 1; }
/usr/bin/gridcoinresearchd backupprivatekeys || { echo "backupprivatekeys failed"; exit 1; }
/usr/bin/gridcoinresearchd backupwallet || { echo "backupwallet failed"; exit 1; }
/usr/bin/gridcoinresearchd walletlock || { echo "walletlock failed"; exit 1; }
/usr/bin/gridcoinresearchd walletpassphrase `cat $HOME/.passme.gpg.asc | gpg -d 2> /dev/null` 43200 true || { echo "walletpassphrase failed"; exit 1; }

exit 0
