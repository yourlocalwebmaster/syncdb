#!/bin/bash
dir=$(dirname $0)
. $dir/syncdb.cfg

if [ -w ${saveBackupPath} ]; then
    ## Backup Current Database
    if mysqldump -h ${db_A_host} -u ${db_A_user} -p${db_A_pass} ${db_A_name} > ${saveBackupPath}/${db_A_name}_backup_${current_time}.sql; then
    ## Export Database B
        if mysqldump -h ${db_B_host} -u ${db_B_user} -p${db_B_pass} ${db_B_name} > ${saveBackupPath}/${db_B_name}_tmp.sql; then
    ## Clear current database.
            if mysql -h ${db_A_host} -u ${db_A_user} -p${db_A_pass} ${db_A_name} < ${dir}/droptables.sql; then
    ## Import Database B into Database A

                if mysql -h ${db_A_host} -u ${db_A_user} -p${db_A_pass} ${db_A_name} < ${saveBackupPath}/${db_B_name}_tmp.sql; then
                     echo "\r\n";
                     echo "\e[93mSync Suceeded!\e[0m";
                     echo "\r\n";
                else
                     echo "\r\n";
                     echo "\e[31mUnable to import Database B into Database A\e[0m";
                     echo "\r\n";
                fi
            else
                echo "\r\n";
                echo "\e[31mUnable to drop database tables from Database A\e[0m";
                echo "\r\n";
            fi
        else
                echo "\r\n";
                echo "\e[31mUnable export database Database B"\e[0m;
                echo "\r\n";
        fi
    else
            echo "\r\n";
            echo "\e[31mUnable to backup database A\e[0m";
            echo "\r\n";
    fi
else
    echo "\r\n"
    echo "\e[31mYou need to make sure your saveBackupPath in ${dir}/syncdb.cfg is writable.\e[0m"
    echo "\r\n"
    exit
fi
