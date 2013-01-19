role :app, "192.34.60.3"
role :web, "192.34.60.3"
role :db, "192.34.60.3", :primary => true
set :rails_env, 'development'
set :branch, 'master'
set :deploy_to, "/root/cap_script/development/#{application}"
