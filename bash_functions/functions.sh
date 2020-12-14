export Color_Off='\033[0m'       # Text Reset
export White='\033[0;37m'        # White
export UGreen='\033[4;32m'       # Green
export BIYellow='\033[1;93m'     # Yellow
export Green='\033[0;32m'        # Green
export Red='\033[0;31m'          # Red

mod_visible() {
    eval $cmd
}

info_start_u() {
  echo "${BIYellow}INFO: ${UGreen}$text${Color_off}${White}"
}

info_start() {
  echo "${BIYellow}INFO: ${Green}$text${Color_off}${White}"
}

run_cmd_db() {
    docker exec -ti postgresql psql -U $user $db -c "$text"
}

progress() {
    printf '\b%.1s' "$sp"
    sp=${sp#?}${sp%???}
}

check_3000() {
    sp='/-\|'
    
    x=1
    y=20
    while [ $x -le $y ]; do
        printf '\b%.1s' "$sp"
        sp=${sp#?}${sp%???}

        if [ "$(curl -s -o /dev/null -w ''%{http_code}'' http://localhost:3000)" == "200" ]; then
            echo ''
            text="Response localhost:3000 == 200" && info_start
            text="_______________Open tab in Chrome__________________" && info_start_u
            open -a "Google Chrome" http://localhost:3000
            break
        fi
        sleep 0.5

    x=$(( $x + 1 ))
    
    if [ $x == $y ]; then
        echo ''
        text="Response localhost:3000 != 200 !!!!"
        echo "${BIYellow}INFO: ${Red}$text${Color_off}${White}"
    fi
    done
}

check_3001() {
    sp='/-\|'
    
    x=1
    y=20
    while [ $x -le $y ]; do
        printf '\b%.1s' "$sp"
        sp=${sp#?}${sp%???}

        if [ "$(curl -s -o /dev/null -w ''%{http_code}'' http://localhost:3001)" == "200" ]; then
            echo ''
            text="Response localhost:3001 == 200" && info_start
            text="_______________Open tab in Chrome__________________" && info_start_u
            open -a "Google Chrome" http://localhost:3001
            break
        fi
        sleep 0.5

    x=$(( $x + 1 ))
    
    if [ $x == $y ]; then
        echo ''
        text="Response localhost:3001 != 200 !!!!"
        echo "${BIYellow}INFO: ${Red}$text${Color_off}${White}"
    fi
    done
}

run_panel_server() {
    text="____________Run migration_______________" && info_start_u
    docker exec -ti panel bundle install
    text="${migration_commands_panel}" && info_start
    $migration_commands_panel
    
    text="____________Run server_______________" && info_start_u
    text="${server_commands} -p 3000" && info_start
    
    docker exec -ti -d panel $server_commands -p 3000
    docker exec -ti -d panel rm -rf /opt/app/tmp/pids/server.pid
}

run_panel_master_server(){
    text="____________Run migration_______________" && info_start_u
    docker exec -ti panel_master bundle install
    text="${migration_commands_panel_master}" && info_start
    $migration_commands_panel_master

    text="____________Run server_______________" && info_start_u
    text="${server_commands} -p 3001" && info_start

    docker exec -ti -d panel_master $server_commands -p 3000
    docker exec -ti -d panel_master rm -rf /opt/app/tmp/pids/server.pid
}
