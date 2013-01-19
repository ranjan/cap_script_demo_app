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
#after "deploy:setup", "update_ownership"
#after "deploy:update_code", "unpack_build_gems"
#before "deploy:create_symlink", "update_ownership"

#set :rake, "/opt/ree/gems/bin/rake"
#set(:rake) { "PATH=$PATH:/opt/ree/gems/bin/rake GEM_HOME=/home/#{user}/data/rubygems/gems rake" }

#task :update_ownership do
#  run "#{try_sudo} chown -R #{user}:users #{deploy_to}"
#  run "#{try_sudo} chown -R #{user}:users #{deploy_to}/*"
#end

desc "Link database.yml"
task :link_production_db do
  run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
end

desc "Building Native gems"
task :unpack_build_gems do
  run "echo `which rake`"
  run "rake gems:unpack"
  run "rake gems:build"
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

after "deploy:update_code", :bundle_install