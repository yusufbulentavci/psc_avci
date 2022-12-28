select count(*) from pg_subscription_rel where srsubstate<>'r';
/0 olmali


max_wal_senders=30 olmali


select pg_terminate_backend(pid) FROM pg_stat_activity where backend_type='client backend' and pid<>pg_backend_pid() and datname='$publisher_db';
