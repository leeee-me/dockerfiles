#!/bin/bash

/bin/ps -axfww | /bin/grep -v grep | /bin/grep -q gridcoinresearch; [ ${PIPESTATUS[2]} -ne 0 ] && echo "GridcoinResearchD is gone" && exit 1

[ ! -z "$2" ] && {
for i in `/usr/bin/gridcoinresearchd listaddressgroupings | sed -s 's/[]"\[,\ \]//g' | grep -v -e '^$' -e '""' | grep -v -e '^[^SR0-9]'`; do 
	A=$i
	[ "x$B" != "x" ] && \
		{ echo -n $B" - " && /usr/bin/gridcoinresearchd dumpprivkey $B; true; } && \
		unset B && unset A
       	[ "x$B" == "x" ] && B=$A
done;
exit 0;
}

unset A
unset B
SUM="0.0"
for i in `/usr/bin/gridcoinresearchd listaddressgroupings | sed -s 's/[]"\[,\ \]//g' | grep -v -e '^$' -e '""' | grep -v -e '^[^SR0-9]'`; do 
	A=$i
	[ -z "$1" ] && [ "x$B" != "x" ] && \
		{ [ "x$A" != "x0.00000000" ] && echo -n ${B:0:5}" ...................... "${B:(-5)}" - " && /usr/bin/gridcoinresearchd dumpprivkey $B; true; } && \
		unset B && unset A
	[ ! -z "$1" ] && [ "x$B" != "x" ] && \
		{ [ "x$A" != "x0.00000000" ] && echo -n $B" - " && /usr/bin/gridcoinresearchd dumpprivkey $B; true; } && \
		unset B && unset A
       	[ "x$B" == "x" ] && B=$A
done

