echo ''
    text="__________________Restor DB__________________" && info_start_u
    text="${path_to_backup_db}" && info_start
    
    add_function() {
            text="CREATE TABLE \"notifications\" (
                \"id\" bigserial NOT NULL,
                \"kind\" character varying NOT NULL DEFAULT 'email',
                \"pid\" integer NOT NULL DEFAULT '0',
                \"is_sent\" boolean NOT NULL DEFAULT false,
                \"author_id\" integer NOT NULL DEFAULT '0',
                \"recipient_id\" integer NULL,
                \"address\" character varying NOT NULL,
                \"title\" character varying NOT NULL,
                \"message\" text NOT NULL,
                \"params\" jsonb NOT NULL,
                \"created_at\" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
                \"updated_at\" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
                \"begin_at\" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP           
            );"
        
            docker exec -ti postgresql psql -U finances_user_main finances_main -c "$text"


    }
    
    text="Start restore DB!!!!!"
    echo "${BIYellow}INFO: ${Red}$text${Color_off}${White}"
    docker exec -ti panel rm -rf vendor/bundler/
    git checkout develop -- $(pwd)/db/structure.sql
    docker exec -i postgresql psql -U finances_user_main finances_main -a < ./bash_functions/data/finances_main.sql

    # docker cp bash_functions/data/panel_dump.sql postgresql:/ &> /dev/null
    # docker exec -ti postgresql pg_restore  -d postgres -c -n public -O -U finances_user_main panel_dump.sql &> /dev/null
    # docker exec -ti postgresql pg_restore -U postgres panel_dump.sql &> /dev/null
    text="\Finish restore DB!!!!!"
    echo "${BIYellow}INFO: ${Red}$text${Color_off}${White}"
    add_function
