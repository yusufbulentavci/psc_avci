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
echo "publisher_user=$publisher_user"
echo "publisher_user_pwd=$publisher_user_pwd"

psql $publisher_db << EOF
create subscription $publish_name connection 'host=$publisher_server port=$publisher_port dbname=${publisher_db} user=${publisher_user} password=${publisher_user_pwd}' publication $publish_name;
EOF


echo "## Done"
