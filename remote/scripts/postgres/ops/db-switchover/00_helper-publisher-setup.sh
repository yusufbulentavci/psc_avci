ilkp=$1
ilka=(${ilkp//:/ })
export cls=${ilka[0]}
export clsop=${ilka[1]}
[[ $PSC_RUN_COMMON != yes ]] && source /var/lib/psc/scripts/common.sh

# ./helper-publisher-setup.sh testi 10.200.236.31 bbs bbsrep pwd bbs,kys,metop 

# ./helper-publisher-setup.sh pgtest 10.150.168.16 eviz testrep testreppwd eviz

hst=$(hostname)

if [ -z "$clsop" ]; then
	echo "Operator should be defined for this script"
	exit 1
fi


echo "### HELPER FOR DB-SWITCHOVER CONFIGURATION"

echo "subscriber_server=$subscriber_server"
echo "publisher_db=$publisher_db"
echo "publisher_user=$publisher_user"
echo "publisher_user_pwd=$publisher_user_pwd"
echo "publish_schemas=$publish_schemas"

echo "##Helper for publisher site"
echo "# postgresql user creation"
echo "create user ${publisher_user} with encrypted password '${publisher_user_pwd}'  replication;"
echo "grant connect on database ${publisher_db} to ${publisher_user};"
for i in "${publish_schemas[@]}"
do
    echo "grant usage on schema $i to ${publisher_user};"
    echo "grant select on all tables in schema $i to ${publisher_user};"
done

echo "# pg_hba.conf"
echo "host    all     all            $subscriber_server/32            scram-sha-256"
echo ""

echo "# postgresql.conf/ needs restart"
echo "listen_addresses = '*'"
echo "wal_level = logical"
echo "max_replication_slots=40"


