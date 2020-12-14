echo ''
               
    text="____________Preconditions  DB________________" && info_start_u
    text="${path_to_backup_db}" && info_start
    
    # text="${mbus_commands}" && info_start
    # cmd="${mbus_commands}" && mod_visible

    text="${postgres_conf}" && info_start
    cmd="${postgres_conf}" && mod_visible

    text="Restart postgresql'" && info_start
    cmd="docker restart postgresql" && mod_visible

    # text="Apt update" && info_start
    # cmd="docker exec -ti postgresql apt update" && mod_visible

    # text="Apt install postgresql-10-ip4r" && info_start
    # cmd="docker exec -ti postgresql apt install -y postgresql-10-ip4r nano" && mod_visible


    text="_________________DB_________________" && info_start_u
    text="Run commands for db finances_main" && info_start

    user=postgres && db=""
      ###panel
        sleep 10
        text="CREATE ROLE finances_user_main WITH LOGIN ENCRYPTED PASSWORD 'password';"
        run_cmd_db && info_start
        
        text="CREATE ROLE runner WITH LOGIN SUPERUSER PASSWORD 'password';"
        run_cmd_db && info_start

        text="CREATE ROLE finances_user_spok WITH LOGIN ENCRYPTED PASSWORD 'password';"
        run_cmd_db && info_start
        
        text="CREATE DATABASE finances_main WITH OWNER finances_user_main LC_CTYPE 'C' LC_COLLATE 'C' template template0 ;"
        run_cmd_db && info_start
      
      ###inventory  
        db=finances_main

        # text="CREATE EXTENSION hstore;"
        # run_cmd_db && info_start
        text="CREATE EXTENSION ip4r;"
        run_cmd_db && info_start
        text='
            CREATE OR REPLACE FUNCTION currencies_update_currency_rate(
                f_currency_id integer,
                f_date date,
                f_rate decimal(15,6)
            )
                RETURNS integer AS
            $BODY$
            DECLARE

            BEGIN

                RAISE DEBUG "currencies_update_currency_rate() is called.";

                --

                PERFORM *

                    FROM currencies_rates

                    WHERE   currency_id = f_currency_id AND
                            currency_day = f_date;

                IF FOUND THEN
                    RETURN 0;
                END IF;

                --

                INSERT INTO currencies_rates

                    SELECT  nextval("currencies_rates_rate_id_seq"::regclass),
                            f_currency_id,
                            f_date,
                            f_rate,
                            now(),
                            now();

                --

                RETURN 1;

            END
            $BODY$
                LANGUAGE plpgsql VOLATILE;



            CREATE OR REPLACE FUNCTION common_get_id_by_index(
                f_table_name varchar,
                f_index varchar
            )
                RETURNS integer AS
            $BODY$
            DECLARE
                id bigint;
            BEGIN

                EXECUTE "SELECT id

                    FROM " || f_table_name || "

                    WHERE index = """ || f_index || """;" INTO id;

                IF id IS NULL THEN
                    RAISE EXCEPTION "Dictionary % does not contain index %.", f_table_name, f_index;
                END IF;

                RETURN id;

            END
            $BODY$
                LANGUAGE plpgsql IMMUTABLE;'
        run_cmd_db && info_start

        text="CREATE ROLE finances_user_inventory WITH LOGIN ENCRYPTED PASSWORD 'password';"
        run_cmd_db && info_start
        text="create database finances_user_spok with owner finances_user_inventory;"
        run_cmd_db && info_start

        text="REVOKE ALL ON ALL TABLES IN SCHEMA public FROM finances_user_inventory; CREATE SCHEMA spok; CREATE SCHEMA inventory;"
        run_cmd_db && info_start

        text="
            GRANT USAGE, CREATE ON SCHEMA inventory TO finances_user_inventory; 
            GRANT USAGE, CREATE ON SCHEMA spok TO finances_user_spok;

            GRANT USAGE ON SCHEMA inventory TO finances_user_main;
            GRANT ALL privileges on ALL TABLES IN SCHEMA inventory TO finances_user_inventory;
            
            GRANT SELECT ON TABLE
                public.projects,
                public.projects_types,
                public.employees,
                public.employees_distributions,
                public.employees_distribution_history,
                public.properties,
                public.properties_distributions,
                public.schema_migrations
            TO finances_user_inventory;
        
        
            GRANT SELECT ON TABLE 
                inventory.equipments,
                inventory.equipment_statuses,
                inventory.equipment_statuses_id_seq 
            TO finances_user_main;"
        run_cmd_db && info_start


        
        # text="CREATE EXTENSION mbus;"
        # run_cmd_db && info_start
        # text="SELECT mbus.create_queue('queues_notifications', 2);"
        # run_cmd_db && info_start
        # text="GRANT ALL ON SCHEMA mbus TO finances_user_main;"
        # run_cmd_db && info_start
        # text="GRANT ALL ON ALL TABLES IN SCHEMA mbus TO finances_user_main;"
        # run_cmd_db && info_start
        # text="GRANT ALL ON ALL SEQUENCES IN SCHEMA mbus TO finances_user_main;"
        # run_cmd_db && info_start

        # text="GRANT ALL ON SCHEMA mbus TO finances_user_inventory;"
        # run_cmd_db && info_start
        # text="GRANT ALL ON ALL TABLES IN SCHEMA mbus TO finances_user_inventory;"
        # run_cmd_db && info_start
        # text="GRANT ALL ON ALL SEQUENCES IN SCHEMA mbus TO finances_user_inventory;"
        # run_cmd_db && info_start
