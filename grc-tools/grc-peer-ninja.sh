#/bin/bash

# check root
[ ! -z "$EUID" ] && { echo "NON-ROOT"; exit 1; }

for i in `sudo netstat -auntpW | grep  gridco | awk '{print $5}' | grep -v ::: | grep -v 0.0.0.0 | sed 's/:32749//'`; do ninja-api $i; done
