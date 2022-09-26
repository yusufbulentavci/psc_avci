ilkp=$1
ilka=(${ilkp//:/ })
export cls=${ilka[0]}
export clsop=${ilka[1]}
[[ $PSC_RUN_COMMON != yes ]] && source /var/lib/psc/scripts/common.sh

hst=$(hostname)


if [ -z "$clsop" ]; then
	echo "Operator should be defined for this script"
	exit 1
fi

echo "publish_name=$publish_name"
echo "publisher_db=$publisher_db"

psql -c "alter subscription $publisher_name disable; alter subscription $publisher_name set (slot_name=none); drop subscription $publisher_name;" $publisher_db
