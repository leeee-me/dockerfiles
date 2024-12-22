#!/bin/bash

[ -z "$1" ] && { echo $0 "<researchd command>"; exit 1; }

docker exec -t gridcoin su - me -c "/usr/bin/gridcoinresearchd $*"

exit $?
