#!/usr/bin/env bash
# Original Author:       Lesovsky A.V.
# Author:       edib
# Description:  Pgbouncer connected users auto-discovery

if [ ! -f ~zabbix/.pgpass ]; then echo "ERROR: ~zabbix/.pgpass not found" ; exit 1; fi

hostname=$(head -n 1 ~zabbix/.pgpass |cut -d: -f1)
port=$(head -n 1 ~zabbix/.pgpass |cut -d: -f2)
username=$(head -n 1 ~zabbix/.pgpass |cut -d: -f4)
dbname="pgbouncer"

if [ '*' = "$hostname" ]; then hostname="127.0.0.1"; fi

userlist=$(psql -h $hostname -p $port -U $username -tA --dbname=$dbname -c "show pools" |awk -F"|" '{print $2}' | uniq | grep -v ^pgbouncer)


echo -n '{"data":['
for user in $userlist; do echo -n "{\"{#USERNAME}\": \"$user\"},"; done |sed -e 's:\},$:\}:'
echo -n ']}'
