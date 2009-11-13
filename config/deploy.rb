# Methods of deployment. One will deploy to the test server, the other deploys to
# production. They should be used as:
#   $ cap production deploy
task :production do
  set :domain, 'madisonbrass.com'
  use_minusuu
end

task :staging do
  set :domain, 'mbb-test.minusuu.com'
  set :keep_releases, 1
  use_minusuu
end

# Sets up to use Tack's server at minusuu.com for the deployment.
task :use_minusuu do
  set :user, 'minusuu'
  set :server_hostname, 'minusuu.com'
  set :deploy_to, "/home/#{user}/sites/#{domain}"
  role :app, server_hostname
  role :web, server_hostname
  role :db,  server_hostname, :primary => true
end

# Point to the code repository wherefrom to get the stuff.
set :scm, 'git'
set :repository, 'git://github.com/ajtack/mbb.git'
ssh_options[:forward_agent] = true
set :branch, 'fb_212_move_to_hostingrails'
set :git_shallow_clone, 1
set :git_enable_submodules, 1
set :use_sudo, false
set :deploy_via, :remote_cache

#
# For a cold (first-time) deploy, this sets up the log files which the server will
# use. They are shared across deployments and automatically linked by default
# Rails recipes.
#
before 'deploy:cold' do
  run "mkdir -p #{deploy_to}/shared/log"
  run "touch #{deploy_to}/shared/log/production.log"
  run "chmod 0666 #{deploy_to}/shared/log/*.log"
end

#
# We trigger the following recipes after a deployment, which are not the default:
#
#  deploy:cleanup - Default Rails recipe. Removes older releases that take up space.
#        The keep_releases variable controls how many are left after each cleanup.
#        The only reason to keep the old versions around is if something were to go
#        wrong (in which case you might run `cap deploy:rollback`).
#
#  deploy:link_db_config - A new recipe that links the application's private database
#        configuration to an existing global configuration for the server. This way,
#        you don't have to leave a password in version control.
#
#  deploy:migrate - Default Rails recipe. Runs migrations. For some reason, this isn't
#        a natural part of a deployment, even though not migrating would obviously
#        break things.
#
after 'deploy', 'deploy:cleanup'
before 'deploy:start', 'deploy:link_db_config'
after 'deploy:link_db_config', 'deploy:migrate'

#
# New and overridden task definitions follow.
#
namespace :passenger do
  desc "Restarts a Passenger instance on the server."
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

namespace :deploy do
  desc "Performs a cold deployment which assumes no existing setup on the server."
  task :cold do
    update
    load_schema
    start
  end
  
  desc "Restarting mod_rails with restart.txt"
  task :restart do
    find_and_execute_task('passenger:restart')
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with Passenger."
    task t, :roles => :app do ; end
  end
end

namespace :deploy do
  desc "Symlinks the database.yml"
  task :link_db_config, :roles => :app do
    run "ln -nfs #{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml"
  end
  
  desc 'Skips migrations if this is a cold deployment'
  task :load_schema, :roles => :app do
    run "cd #{current_path}; rake db:schema:load"
    run "cd #{current_path}; rake db:defaults:load"
  end
end