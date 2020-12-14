server_commands="rails s -b 0.0.0.0"
migration_commands_panel="docker exec -ti panel bin/rails db:migrate RAILS_ENV=development"
migration_commands_panel_master="docker exec -ti panel_master bin/rails db:migrate RAILS_ENV=development"
path='./bash_functions/data'
mbus_commands='docker cp '${path}'/mbus-1.0-stable/. postgresql:/usr/share/postgresql/10/extension'
postgres_conf='docker cp '${path}'/postgresql.conf postgresql:/var/lib/postgresql/data/'

path_to_backup_db=${path}'/dev_b4_2018.0912.15.dump'

# dev_b4_2018.1009.13.sql
. bash_functions/functions.sh
. bash_functions/preconditions.sh
. bash_functions/up_and_setting.sh
. bash_functions/action_db.sh
. bash_functions/restore_db.sh


echo ''
    text="____________Docker list______________" && info_start_u
    echo "\n"
    docker ps -a

. bash_functions/run_server.sh

# ActiveRecord::Base.connection.tables.each { |t|     ActiveRecord::Base.connection.reset_pk_sequence!(t) }
