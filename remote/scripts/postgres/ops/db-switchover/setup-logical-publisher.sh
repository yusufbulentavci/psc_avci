ilkp=$1
ilka=(${ilkp//:/ })
export cls=${ilka[0]}
export clsop=${ilka[1]}
[[ $PSC_RUN_COMMON != yes ]] && source /var/lib/psc/scripts/common.sh

# requirement
# postgres user no password ssh connection needed
# create user $publisher_user with encrypted password $publisher_user_pwd;
# publisher user is created and hba accessed granted

# ./setup-logical-publisher.sh testi 10.200.236.31 5432 bbs bbsrep pwd bbstasi bbs,kys,metop

# ./setup-logical-publisher.sh pgtest 10.150.153.21 5432 eviz testrep testreppwd eviztasi eviz

hst=$(hostname)

publisher_server=$2
publisher_port=$3

publisher_db=$4

publisher_user=$5
publisher_user_pwd=$6

publish_name=$7

# comman seperated schemas in 7
publish_schemas=(${8//,/ })
schema_arg=""
for i in "${publish_schemas[@]}"
do
    schema_arg="${schema_arg} -n $i"
done

echo "publish_name=$publish_name"
echo "publisher_server=$publisher_server"
echo "publisher_port=$publisher_port"
echo "publisher_db=$publisher_db"
echo "publisher_user=$publisher_user"
echo "publisher_user_pwd=$publisher_user_pwd"
echo "publish_schemas=$publish_schemas"


# Connect to publisher server and take a dump of db
# Create publication
ssh $publisher_server << EOF
rm -f /tmp/pscdumplp.sql
pg_dumpall -p $publisher_port -r > /tmp/pscdumplp.sql
pg_dump -p $publisher_port --create --schema-only $schema_arg $publisher_db >> /tmp/pscdumplp.sql

psql -p $publisher_port $publisher_db << IEOF
create publication $publish_name for all tables;
IEOF

EOF

rm -f /tmp/pscdumplp.sql
scp $publisher_server:/tmp/pscdumplp.sql /tmp/pscdumplp.sql

psql -f /tmp/pscdumplp.sql

psql $publisher_db << EOF
create subscription $publish_name connection 'host=$publisher_server port=$publisher_port dbname=${publisher_db} user=${publisher_user} password=${publisher_user_pwd}' publication $publish_name;
EOF



