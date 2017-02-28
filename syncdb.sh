#!/bin/bash
dir=$(dirname $0)
. $dir/syncdb.cfg

## TODO: Exit if any part in the flow fails. I.E, if DB B doesn't export, don't delete DB A.
if [ -w ${saveBackupPath} ]; then
        ## Backup Current Database
        mysqldump -h ${db_A_host} -u ${db_A_user} -p${db_A_pass} ${db_A_name} > ${saveBackupPath}/${db_A_name}_backup_${current_time}.sql
        ## Export Database B
        mysqldump -h ${db_B_host} -u ${db_B_user} -p${db_B_pass} ${db_B_name} > ${saveBackupPath}/${db_B_name}_tmp.sql
        ## Clear current database.
        mysql -h ${db_A_host} -u ${db_A_user} -p${db_A_pass} ${db_A_name} < /var/www/SyncDB/droptables.sql
        ## Import Database B into Database A
        mysql -h ${db_A_host} -u ${db_A_user} -p${db_A_pass} ${db_A_name} < ${saveBackupPath}/${db_B_name}_tmp.sql
else
    echo "\r\n"
    echo "You need to make sure your savePath is writable."
    echo "\r\n"
    exit
fi