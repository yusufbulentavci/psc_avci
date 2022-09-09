#!/usr/bin/env bash
# Author:       Avci
# Author:       Lesovsky A.V.
# Description:  Pgbouncer pools auto-discovery



poollist=$(psql -qAtXF: --dbname=pgbouncer -c "show pools" |cut -d: -f1,2 |grep -v ^pgbouncer)

echo -n '{"data":['
for pool in $poollist; do echo -n "{\"{#POOLNAME}\": \"$pool\"},"; done |sed -e 's:\},$:\}:'
echo -n ']}'
