#!/usr/bin/env bash
# Original Author:      Lesovsky A.V.
# Author:               edib
# Description:  Pgbouncer user based pools stats
# $1 - param_name, $2 - pool_name

if [ ! -f ~zabbix/.pgpass ]; then echo "ERROR: ~zabbix/.pgpass not found" ; exit 1; fi

PSQL=$(which psql)

hostname=$(head -n 1 ~zabbix/.pgpass |cut -d: -f1)
port=$(head -n 1 ~zabbix/.pgpass |cut -d: -f2)
username=$(head -n 1 ~zabbix/.pgpass |cut -d: -f4)
dbname="pgbouncer"
PARAM="$1"

if [ '*' = "$hostname" ]; then hostname="127.0.0.1"; fi

conn_param="-qAtX -F: -h $hostname -p $port -U $username $dbname"

case "$PARAM" in
'cl_active' )
        $PSQL $conn_param -c "show pools" |grep -w ^$2 | awk -d: -f3
;;
* ) echo "ZBX_NOTSUPPORTED"; exit 1;;
esac