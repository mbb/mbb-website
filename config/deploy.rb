set :application, 'mbb-test'
set :user, 'minusuu'
set :domain, 'mbb-test.minusuu.com'
set :deploy_to, '/home/minusuu/sites/mbb-test.minusuu.com'
set :server_hostname, 'minusuu.com'

set :scm, 'git'
set :repository, 'git://github.com/ajtack/mbb.git'
ssh_options[:forward_agent] = true
set :branch, 'master'
set :deploy_via, :remote_cache
set :git_shallow_clone, 1
set :git_enable_submodules, 1
set :git_update_submodules, 1
set :use_sudo, false
set :deploy_to, "/home/#{user}/sites/#{domain}"

role :app, server_hostname
role :web, server_hostname
role :db,  server_hostname, :primary => true

after 'deploy', 'deploy:cleanup'
after 'deploy:update_code', 'deploy:symlink_db'

namespace :passenger do
  desc "Restart Application"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

namespace :deploy do
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
  task :symlink_db, :roles => :app do
    run "ln -nfs #{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml"
  end
  
  desc 'Skips migrations if this is a cold deployment'
  task :load_schema, :roles => :app do
    run "cd #{current_path}; rake db:schema:load"
    run "cd #{current_path}; rake db:defaults:load"
  end
end