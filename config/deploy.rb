set :application, "voipontel"
set :repository,  "git@github.com:adamk1369/ap2.git"

#set :keep_releases, 5

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
set :scm, :git
set :branch, 'master'
set :user, 'ranjan'
set :use_sudo, true
default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :deploy_via, :remote_cache
set :scm_verbose, true

set :stages, %w(development staging_production production)
set :default_stage, "development"
require 'capistrano/ext/multistage'


after "deploy:create_symlink", :link_production_db
after "deploy:setup", "update_ownership"
after "deploy:update_code", "unpack_build_gems"
before "deploy:create_symlink", "update_ownership"
set :rake, "/opt/ree/gems/bin/rake"
#set(:rake) { "PATH=$PATH:/opt/ree/gems/bin/rake GEM_HOME=/home/#{user}/data/rubygems/gems rake" }
task :update_ownership do
  run "#{try_sudo} chown -R #{user}:users #{deploy_to}"
  run "#{try_sudo} chown -R #{user}:users #{deploy_to}/*"
end

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


# If you are using Passenger mod_rails uncomment this:
namespace :deploy do

  task :start do
    ;
  end
  task :stop do
    ;
  end
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => {:no_release => true} do
    run "#{try_sudo} touch #{File.join(current_path, 'tmp', 'restart.txt')}"
  end
end
