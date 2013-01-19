role :app, "localhost"
role :web, "localhost"
role :db, "localhost", :primary => true
set :rails_env, 'production'
set :branch, 'master'
set :deploy_to, "/home/ranjan/vot/production/#{application}"

after "deploy:create_symlink", :link_production_env

desc "Replacing Production.rb"
task :link_production_env do
  run "ln -nfs #{deploy_to}/shared/config/production.rb #{release_path}/config/environments/production.rb"
end
