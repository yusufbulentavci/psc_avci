ilkp=$1
ilka=(${ilkp//:/ })
export cls=${ilka[0]}
export clsop=${ilka[1]}
[[ $PSC_RUN_COMMON != yes ]] && source /var/lib/psc/scripts/common.sh


echo "#### Switch synch mode "
echo "## alter subscription $publish_name set (synchronous_commit=remote_apply);"

echo "publish_name=$publish_name"
echo "publisher_db=$publisher_db"

psql $publisher_db << EOF
alter subscription $publish_name set (synchronous_commit=remote_apply);
EOF

echo "Done"

