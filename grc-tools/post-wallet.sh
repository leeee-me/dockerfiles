#!/bin/bash

cd $HOME

PASSME=
[ -f .postpass.gpg ] && PASSME="-pass pass:`gpg -d -o - .postpass.gpg 2> /dev/null`"
[ -z "$PASSME" ] && exit 1

/bin/tar --newer-mtime '14 days ago' -cjf $HOME/.GridcoinResearch/wallet-backups.tbz2 $HOME/.GridcoinResearch/walletbackups/

[ ! -f $HOME/.GridcoinResearch/wallet-backups.tbz2 ] && exit 1
echo "Total `/bin/tar tjf $HOME/.GridcoinResearch/wallet-backups.tbz2 | grep walletbackups | wc -l` file(s) backup"

mv $HOME/.GridcoinResearch/wallet-backups.tbz2  $HOSTNAME-grc_wa.dat

HOSTNAME=`hostname -s`

openssl enc -a -aes-256-cbc -md sha256 -pbkdf2 -salt $PASSME -in  $HOSTNAME-grc_wa.dat -out $HOSTNAME-grc_wa.dat.enc
rm -rf $HOSTNAME-grc_wa.dat

FILE=$HOSTNAME-grc_wa.dat.enc-`date +%s`
mv $HOSTNAME-grc_wa.dat.enc gridcoin-wallet/$FILE
SUM=`cat gridcoin-wallet/$FILE | sha256sum | cut -d' ' -f1`

cd gridcoin-wallet
git pull --no-edit
git add $FILE
for i in `ls -t $HOSTNAME-*enc-* | tail -n +4`; do git rm $i; done
git commit -a -s -m "openssl enc -a -aes-256-cbc -md sha256 -pbkdf2 -salt -d -in $FILE" \
                 -m "# ${SUM}"
git push --all

cd $HOME

exit 0
