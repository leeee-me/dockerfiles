#!/bin/bash

/bin/ps -axfww | /bin/grep -v grep | /bin/grep -q gridcoinresearch; [ ${PIPESTATUS[2]} -ne 0 ] && echo "GridcoinResearchD is gone" && exit 1
CC=
B=`/usr/bin/gridcoinresearchd getmininginfo | jq -r '.CPID'`

while (($# > 0)); do
        if [ "x$1" == "xall" ]; then
                ALL=1
        elif [ "x$1" == "xresult" ]; then
                RESULT=1
        elif [ "x$1" == "xmy" ]; then
                MY=1
        elif [ "x$1" == "xfilter" ]; then
                FILTER="$2"
                shift
	elif [ "x$1" == "xh" -o "x$1" == "xhelp" ]; then
		/bin/echo "options are \`all', \`result', \`my', and \`filter'" 1>&2 
		exit 0
        else
                /bin/echo "$1: option ignored" 1>&2
        fi
        shift
done

for i in `/usr/bin/gridcoinresearchd listpolls | jq -r '.[] | .id'`; do
	[ ! -z "$FILTER" ] && { [ "$FILTER" != "$i" ] && continue; }
	echo "--------------------";
	[ ! -z "$ALL" ] && /usr/bin/gridcoinresearchd listpolls | jq -r '.[] | select(.id == "'$i'") | "#: " + .id + " |NT| T: " + .title + " |NT| Q: " + .question + " |NT| U: " + .url + " |NT| X: " + .expiration + " |NT| C: " + (.choices|tostring)' | sed 's/ |NT| /\n  /g'
	[ ! -z "$ALL" ] && { \
	    M= \
	    M=`/usr/bin/gridcoinresearchd listpolls | jq -r '.[] | select(.id == "'$i'") | "_: " + (.additional_fields|tostring)'`; \
	    [ "$M" != "_: []" ] && echo "  $M"; \
	}
	[ -z "$ALL" ] && /usr/bin/gridcoinresearchd listpolls | jq -r '.[] | select(.id == "'$i'") | "#: " + .id + " |NT| T: " + .title + " |NT| X: " + .expiration' | sed 's/ |NT| /\n  /g'
	[ ! -z "$RESULT" ] && { \
	   echo; \
	    /usr/bin/gridcoinresearchd getpollresults $i | jq -r '"|T|total votes: " + (.votes|tostring),"|T|" + (.responses[]|tostring)' | sed 's/|T|/\t/g'; \
	}
	[ ! -z "$MY" ] && { \
	    M= \
	    M=`/usr/bin/gridcoinresearchd votedetails $i | jq -r '.[] | select(.cpid == "'$B'") | "VO: " + (.answers|tostring)'`; \
	    [ ! -z "$M" ] && echo && echo "  $M"; \
	}
	CC="1"
done

echo "--------------------";

[ "x$CC" != "x" ] && { \
    [ ! -z "$MY" ] && { \
	echo; \
	echo "gridcoinresearchd walletlock"; \
	echo -n "gridcoinresearchd " && /usr/bin/gridcoinresearchd help walletpassphrase | head -n 1; \
	echo "    <timeout> is '300' (secs), and skip '[stakingonly]' not to specify for all unlock"; \
	echo -n "gridcoinresearchd " && /usr/bin/gridcoinresearchd help votebyid | head -n 1; \
	echo "    <poll_id> is '#:', choice_id is 0..n in 'C:'"; \
	echo; \
	echo "--------------------";
    } && exit 1;
} && exit 1

exit 0
