ilkp=$1
ilka=(${ilkp//:/ })
export cls=${ilka[0]}
export clsop=${ilka[1]}
[[ $PSC_RUN_COMMON != yes ]] && source /var/lib/psc/scripts/common.sh

echo "############################"
echo "##Create publication"
echo "publish_name=$publish_name"
echo "publisher_server=$publisher_server"
echo "publisher_port=$publisher_port"
echo "publisher_db=$publisher_db"


# Connect to publisher server and take a dump of db
# Create publication
ssh $publisher_server << EOF
psql -p $publisher_port $publisher_db << IEOF
create publication $publish_name for all tables;
IEOF

EOF

echo "## Done"
