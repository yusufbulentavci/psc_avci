ilkp=$1
ilka=(${ilkp//:/ })
export cls=${ilka[0]}
export clsop=${ilka[1]}
[[ $PSC_RUN_COMMON != yes ]] && source /var/lib/psc/scripts/common.sh

hst=$(hostname)

schema_arg=""
for i in "${publish_schemas[@]}"
do
    schema_arg="${schema_arg} -n $i"
done

echo "############################"
echo "##Transfer database"
echo "publisher_server=$publisher_server"
echo "publisher_port=$publisher_port"
echo "publisher_db=$publisher_db"
echo "publish_schemas=$publish_schemas"

ssh $publisher_server << EOF
rm -f /tmp/pscdumplp.sql
pg_dump -p $publisher_port --create --schema-only $schema_arg $publisher_db > /tmp/pscdumplp.sql
EOF

rm -f /tmp/pscdumplp.sql
scp $publisher_server:/tmp/pscdumplp.sql /tmp/pscdumplp.sql

psql -f /tmp/pscdumplp.sql && echo "Successfull"

echo "## Done"
