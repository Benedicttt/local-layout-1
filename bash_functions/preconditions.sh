    pw=$(pwd)

    # if [[ $branch = '' ]]
    # then
    #     echo ''
    #     text="_____________ Git Checkout  _____________" && info_start_u

    #     echo ''
    #     text="_____________     Panel     _____________" && info_start_u
    #     cd ../panel
    #     git stash
    #     git fetch --all
    #     git checkout -f master
    #     git stash drop
    #     git pull origin master -f
    #     git pull origin develop -f
    #     cd $pw

    #     echo ''
    #     text="_____________ Panel  MASTER _____________" && info_start_u
    #     cd ../panel_master/panel
    #     git stash
    #     git fetch --all
    #     git checkout -f develop
    #     git stash drop
    #     git pull origin develop -f
    #     git pull origin master -f
    #     cd $pw
    #     branch=''

    # else
    #     echo ''
    #     text="_____________ Git Checkout  _____________" && info_start_u

    #     echo ''
    #     text="_____________ Panel $branch _____________" && info_start_u
    #     cd ../panel
    #     git stash
    #     git branch -D $branch
    #     git fetch --all
    #     git checkout -b $branch
    #     git stash drop
    #     git pull origin $branch -f
    #     cd $pw

    #     echo ''
    #     text="_____________ Panel MASTER _____________" && info_start_u
    #     cd ../panel_master/panel
    #     git stash
    #     git fetch --all
    #     git checkout -f develop
    #     git stash drop
    #     git pull origin master -f
    #     cd $pw

    #     branch=''
    # fi

echo ''
text="_______________ Docker _______________" && info_start_u

text="Drop all containers y/n?"
    echo ''; echo "${BIYellow}INFO: ${Red}$text${Color_off}${White}"
    old_stty_cfg=$(stty -g)
    stty raw -echo
    answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
    stty $old_stty_cfg

    if echo "$answer" | grep -iq "^y" ;then
        text="DROP"
        echo "${BIYellow}INFO: ${Green}$text${Color_off}${White}"

        docker stop $(docker ps -a -q)
        docker rm -vf $(docker ps -a -q)
        # docker swarm leave --force
        # docker network prune -f

    else
        text="SKIP" && info_start
        break
    fi
