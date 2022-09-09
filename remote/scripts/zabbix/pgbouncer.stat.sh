#!/usr/bin/env bash
# Author:       Avci
# Author:       Lesovsky A.V.
# Description:  Pgbouncer pools stats
# $1 - param_name, $2 - pool_name

PSQL=$(which psql)

PARAM="$1"

IFS=':'; arr_poolname=($2); unset IFS;

conn_param="-qAtX -F: pgbouncer"

case "$PARAM" in
'avg_req' )
        $PSQL $conn_param -c "show stats" |grep -w ${arr_poolname[0]} |cut -d: -f6
;;
'avg_recv' )
        $PSQL $conn_param -c "show stats" |grep -w ${arr_poolname[0]} |cut -d: -f7
;;
'avg_sent' )
        $PSQL $conn_param -c "show stats" |grep -w ${arr_poolname[0]} |cut -d: -f8
;;
'avg_query' )
        $PSQL $conn_param -c "show stats" |grep -w ${arr_poolname[0]} |cut -d: -f9
;;
'cl_active' )
        $PSQL $conn_param -c "show pools" |grep -w ^$2 |cut -d: -f3
;;
'cl_waiting' )
        $PSQL $conn_param -c "show pools" |grep -w ^$2 |cut -d: -f4
;;
'sv_active' )
        $PSQL $conn_param -c "show pools" |grep -w ^$2 |cut -d: -f5
;;
'sv_idle' )
        $PSQL $conn_param -c "show pools" |grep -w ^$2 |cut -d: -f6
;;
'sv_used' )
        $PSQL $conn_param -c "show pools" |grep -w ^$2 |cut -d: -f7
;;
'sv_tested' )
        $PSQL $conn_param -c "show pools" |grep -w ^$2 |cut -d: -f8
;;
'sv_login' )
        $PSQL $conn_param -c "show pools" |grep -w ^$2 |cut -d: -f9
'cl_active' )
        $PSQL $conn_param -c "show pools" |grep -w ^$2 |cut -d: -f3
;;
'cl_waiting' )
        $PSQL $conn_param -c "show pools" |grep -w ^$2 |cut -d: -f4
;;
'sv_active' )
        $PSQL $conn_param -c "show pools" |grep -w ^$2 |cut -d: -f5
;;
'sv_idle' )
        $PSQL $conn_param -c "show pools" |grep -w ^$2 |cut -d: -f6
;;
'sv_used' )
        $PSQL $conn_param -c "show pools" |grep -w ^$2 |cut -d: -f7
;;
'sv_tested' )
        $PSQL $conn_param -c "show pools" |grep -w ^$2 |cut -d: -f8
;;
'sv_login' )
        $PSQL $conn_param -c "show pools" |grep -w ^$2 |cut -d: -f9
;;
'maxwait' )
        $PSQL $conn_param -c "show pools" |grep -w ^$2 |cut -d: -f10
;;
'free_clients' )
        $PSQL $conn_param -c "show lists" |grep -w free_clients |cut -d: -f2
;;
'used_clients' )
        $PSQL $conn_param -c "show lists" |grep -w used_clients |cut -d: -f2
;;
'login_clients' )
        $PSQL $conn_param -c "show lists" |grep -w login_clients |cut -d: -f2
;;
'free_servers' )
        $PSQL $conn_param -c "show lists" |grep -w free_servers |cut -d: -f2
;;
'used_servers' )
        $PSQL $conn_param -c "show lists" |grep -w used_servers |cut -d: -f2
;;
'total_avg_req' )
        $PSQL $conn_param -c "show stats" |cut -d: -f6 |awk '{ s += $1 } END { print s }'
;;
'total_avg_recv' )
        $PSQL $conn_param -c "show stats" |cut -d: -f7 |awk '{ s += $1 } END { print s }'
;;
'total_avg_sent' )
        $PSQL $conn_param -c "show stats" |cut -d: -f8 |awk '{ s += $1 } END { print s }'
;;
'total_avg_query' )
        $PSQL $conn_param -c "show stats" |cut -d: -f6,9 |awk -F: '{ a += $1 * $2} { b += $1} END { print a / b }'
;;
* ) echo "ZBX_NOTSUPPORTED"; exit 1;;
esac
