#!/usr/bin/env bash
# Original Author:      Lesovsky A.V.
# Author:               edib
# Author:               avci
# Description:  Pgbouncer user based pools stats
# $1 - param_name, $2 - pool_name


PSQL=$(which psql)

PARAM="$1"


conn_param="-qAtX -F: pgbouncer"

case "$PARAM" in
'cl_active' )
        $PSQL $conn_param -c "show pools" |grep -w ^$2 | awk -d: -f3
;;
* ) echo "ZBX_NOTSUPPORTED"; exit 1;;
esac