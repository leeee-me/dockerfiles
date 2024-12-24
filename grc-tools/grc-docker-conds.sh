#!/bin/bash

HOME=/home/leeee

/bin/ps -axfww | /bin/grep -v grep | /bin/grep -q gridcoinresearch; [ ${PIPESTATUS[2]} -ne 0 ] && echo "GridcoinResearchD is gone" && exit 1

grc-docker.sh walletlock || exit 1
grc-docker.sh walletpassphrase `cat $HOME/.passme.gpg.asc | gpg -d 2> /dev/null` 43200 

C=1
for i in `$HOME/.bin/grc-listaddr.sh 1 2 | grep ^S | awk '{ print $1 }'`; do
	echo $C | awk '{printf "[%3d] ", $1}';
	echo -n ${i:0:5}" ...................... "${i:(-5)}" : "; 
	grc-docker.sh consolidateunspent $i | /usr/bin/jq -r 'keys_unsorted[] as $k | "\(.[$k])"' | paste -sd',' -; 
	C=$((C+1));
done

echo 
echo "consolidateunspent:"
$HOME/.bin/grc-listaddr.sh

grc-docker.sh walletlock || exit 1
grc-docker.sh walletpassphrase `cat $HOME/.passme.gpg.asc | gpg -d 2> /dev/null` 43200 true

