#!/bin/bash
ilkp=$1
ilka=(${ilkp//:/ })
export cls=${ilka[0]}
export clsop=${ilka[1]}
[[ $PSC_RUN_COMMON != yes ]] && source /var/lib/psc/scripts/common.sh



db=$2
schema=$3

newowner="tmp_sil_usr_$db_$schema"


echo "This scripts will change owner of schema:$schema and all of its objects to $newowner"
echo "So you can safely drop schema cascade"


echo "new owner:$newowner"

echo "drop role if exists $newowner"
psql -qAt -c "drop role if exists $newowner"

echo "create role $newowner"
psql -qAt -c "create role $newowner"

echo "alter schema $schema owner to $newowner"
psql -qAt  -c "alter schema $schema owner to $newowner" $db


for tbl in $(psql -qAt -c "select tablename from pg_tables where schemaname = '$schema';" $db)
 do  
       echo "alter table $schema.$tbl owner to $newowner" 
       psql -c "alter table $schema.$tbl owner to $newowner" $db 
 done

for seq in $(psql -qAt -c "select sequencename from pg_sequences where schemaname = '$schema';" $db)
 do  
       echo "alter sequence $schema.$seq owner to $newowner" 
       psql -c "alter sequence $schema.$seq owner to $newowner" $db 
 done
 
for viv in $(psql -qAt -c "select viewname from pg_views where schemaname = '$schema';" $db)
 do  
       echo "alter view $schema.$viv owner to $newowner" 
       psql -c "alter view $schema.$viv owner to $newowner" $db 
 done

for proc in $(psql -qAt -c "select proname from pg_proc where pronamespace = (select oid from pg_namespace n where n.nspname='$schema');" $db)
 do  
       echo "alter procedure $schema.$proc owner to $newowner" 
       psql -c "alter procedure $schema.$proc owner to $newowner" $db 
 done

for typ in $(psql -qAt -c "select typname from pg_type where typcategory<>'A' and typrelid=0 and typnamespace = (select oid from pg_namespace n where n.nspname='$schema');" $db)
 do  
       echo "alter type $schema.$typ owner to $newowner" 
       psql -c "alter type $schema.$typ owner to $newowner" $db 
 done

for opr in $(psql -qAt -c "select oprname from pg_operator where oprnamespace = (select oid from pg_namespace n where n.nspname='$schema');" $db)
 do  
       echo "alter operator $schema.$opr owner to $newowner" 
       psql -c "alter operator $schema.$opr owner to $newowner" $db 
 done


echo "=============================="
echo "= drop schema with $newowner"
echo "set role $newowner; drop schema cascade; " 
echo "= reconnect with super user"
echo "drop role $newowner" 
echo "=============================="

