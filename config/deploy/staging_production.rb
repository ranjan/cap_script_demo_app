role :app, "localhost"
role :web, "localhost"
role :db, "localhost", :primary => true
set :rails_env, 'development'
set :branch, 'master'
set :deploy_to, "/home/ranjan/vot/staging/#{application}"
