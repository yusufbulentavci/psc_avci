ilkp=$1
ilka=(${ilkp//:/ })
export cls=${ilka[0]}
export clsop=${ilka[1]}
[[ $PSC_RUN_COMMON != yes ]] && source /var/lib/psc/scripts/common.sh

hst=$(hostname)

echo "############################"
echo "##Transfer globals"
echo "publisher_server=$publisher_server"

ssh $publisher_server << EOF
rm -f /tmp/pscdumplp.sql
pg_dumpall -p $publisher_port -r > /tmp/pscdumplp.sql
EOF

rm -f /tmp/pscdumplp.sql
scp $publisher_server:/tmp/pscdumplp.sql /tmp/pscdumplp.sql

psql -f /tmp/pscdumplp.sql && echo "Successfull"

echo "## Done"



