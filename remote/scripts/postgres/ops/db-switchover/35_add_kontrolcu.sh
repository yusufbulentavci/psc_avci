ilkp=$1
ilka=(${ilkp//:/ })
export cls=${ilka[0]}
export clsop=${ilka[1]}
[[ $PSC_RUN_COMMON != yes ]] && source /var/lib/psc/scripts/common.sh


echo "############################"
echo "##Add kontrolcu to database"

echo "publisher_db=$publisher_db"
echo "auth_user=$auth_user"

psql $publisher_db << EOF
CREATE OR REPLACE FUNCTION public.kullanici_bul(uname TEXT) RETURNS
TABLE (usename name, passwd text) as
$$
  SELECT usename, passwd FROM pg_shadow WHERE usename=\$1;
$$
LANGUAGE sql SECURITY DEFINER;
GRANT EXECUTE ON FUNCTION public.kullanici_bul to $auth_user;
grant USAGE ON SCHEMA public to $auth_user;
EOF

echo "## Done"
