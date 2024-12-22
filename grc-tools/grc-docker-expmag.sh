#!/bin/bash

/bin/ps -axfww | /bin/grep -v grep | /bin/grep -q gridcoinresearch; [ ${PIPESTATUS[2]} -ne 0 ] && echo "GridcoinResearchD is gone" && exit 1

B=`grc-docker.sh getmininginfo | jq -r '.CPID'`
grc-docker.sh explainmagnitude $B | /usr/bin/jq -r 'keys_unsorted[] as $k | "\(.[$k])"'
