export cls=$1
[[ $PSC_RUN_COMMON != yes ]] && source /var/lib/psc/scripts/common.sh

hst=$(hostname)

publisher_server=$2
publisher_name=$3
publisher_db=$4


# 
cat << EOF > /tmp/so_exec.sql
update pg_database set datallowconn=false where datname='$publisher_db';
select pg_terminate_backend(pid) FROM pg_stat_activity where backend_type='client backend' and pid<>pg_backend_pid();
copy (select 'SELECT pg_catalog.setval('''||schemaname||'.'||sequencename||''',' || last_value ||', true);' from pg_sequences where last_value is not null) to '/tmp/so_out.sql';
select pg_wal_lsn_diff(sent_lsn, replay_lsn) as replay_lag from pg_stat_replication where application_name='$publisher_name';
EOF

scp /tmp/so_exec.sql $publisher_server:/tmp/so_exec.sql

latency=$(ssh $publisher_server "psql --quiet -c '\pset tuples_only' -f /tmp/so_exec.sql $publisher_db " || tail -n 1)
echo $latency
latency=$(echo "$latency" | xargs)

echo "latency=-$latency-"

if [ "0" != "$latency" ]; then
	echo "Latency is not 0. Switch over not ready. Go manually"
	exit 1
fi

scp $publisher_server:/tmp/so_out.sql /tmp/so_out.sql

psql -c "alter subscription $publisher_name disable; alter subscription $publisher_name set (slot_name=none); drop subscription $publisher_name;" $publisher_db
psql -f /tmp/so_out.sql $publisher_db
