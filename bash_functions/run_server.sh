echo ''
run_panel_server
run_panel_master_server
sleep 20    
check_3000
check_3001

if [ "$(curl -s -o /dev/null -w ''%{http_code}'' http://localhost:3000)" != "200" ]; then
    run_panel_server
    check_3000
fi
    
if [ "$(curl -s -o /dev/null -w ''%{http_code}'' http://localhost:3001)" != "200" ]; then
    run_panel_master_server
    sleep 20    
    check_3001
fi

text="____________Run TEST_______________" && info_start_u
docker exec -ti panel bundle exec rails db:create db:structure:load db:migrate RAILS_ENV=test
docker exec -ti panel bundle exec rspec
