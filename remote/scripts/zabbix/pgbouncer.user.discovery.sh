#!/usr/bin/env bash
# Original Author:       Lesovsky A.V.
# Author:       edib
# Author:       avci
# Description:  Pgbouncer connected users auto-discovery

userlist=$(psql -tA --dbname=pgbouncer -c "show pools" |awk -F"|" '{print $2}' | uniq | grep -v ^pgbouncer)

echo -n '{"data":['
for user in $userlist; do echo -n "{\"{#USERNAME}\": \"$user\"},"; done |sed -e 's:\},$:\}:'
echo -n ']}'
