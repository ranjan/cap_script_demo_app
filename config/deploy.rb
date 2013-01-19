set :application, "yr_app_name"
set :repository,  "git@github.com:ranjan/cap_script_demo_app.git"

#set :keep_releases, 5

# adjust if you are using RVM, remove if you are not
$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require "rvm/capistrano"
set :rvm_ruby_string, '1.9.3'
set :rvm_type, :system
#set :rvm_bin_path, '/usr/local/rvm/bin/'

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
set :scm, :git
set :branch, 'master'
set :user, 'root'
#set :use_sudo, true
default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :deploy_via, :remote_cache
set :scm_verbose, true

set :stages, %w(development staging_production production)
set :default_stage, "development"
require 'capistrano/ext/multistage'


after "deploy:create_symlink", :link_production_db

desc "Link database.yml"
task :link_production_db do
  run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
end

namespace :deploy do
  desc "cause Passenger to initiate a restart"
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

desc "install the necessary prerequisites"
task :bundle_install, :roles => :app do
  run "cd #{release_path} && bundle install"
end

desc "Rake db:migrate"
task :rake_db_migrate, :roles => [:app, :web] do
  run "cd #{release_path} &&  bundle exec rake db:migrate RAILS_ENV=#{rails_env}"
end


after "deploy:update_code", :bundle_install
before "deploy:symlink", :set_version, :symlink_config
after "deploy:symlink", "rake_db_migrate"
after "deploy:symlink", "assets:precompile"