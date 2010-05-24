# Base methods of deployment. One will deploy to the test server, the other deploys to
# production. This recipe uses capistrano-ext to trigger the recipes in config/deploy.
# They should be used from the root of the rails application as:
#	 $ cap production deploy
require 'capistrano/ext/multistage'

# Sets up to use Darren's server at madisonbrass.com for deployment.
task :use_madisonbrass do
	set :user, 'madison'
	set :server_hostname, 'madisonbrass.com'
	set :deploy_to, "/home/#{user}/sites/#{domain}"
	role :app, server_hostname
	role :web, server_hostname
	role :db,	server_hostname, :primary => true
	
	# This is necessary, else RVM doesn't initialize as expected.
	default_run_options[:shell] = false
end

# Point to the code repository wherefrom to get the stuff.
set :scm, 'git'
set :repository, 'git://github.com/mbb/mbb-website.git'
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
	run "chmod -R 0644 #{deploy_to}/shared/public"
end

#
# We trigger the following recipes after a deployment, which are not the default:
#
#	deploy:cleanup - Default Rails recipe. Removes older releases that take up space.
#				The keep_releases variable controls how many are left after each cleanup.
#				The only reason to keep the old versions around is if something were to go
#				wrong (in which case you might run `cap deploy:rollback`).
#
#	deploy:link_db_config - A new recipe that links the application's private database
#				configuration to an existing global configuration for the server. This way,
#				you don't have to leave a password in version control.
#
#	deploy:migrate - Default Rails recipe. Runs migrations. For some reason, this isn't
#				a natural part of a deployment, even though not migrating would obviously
#				break things.
#
after 'deploy', 'deploy:cleanup'
before 'deploy:migrate', 'host:link_db_config'
before 'deploy:load_schema', 'host:link_db_config'
after "deploy:update_code", "host:copy_assets"
after 'deploy:update_code', 'host:rvm:configure'

#
# New and overridden task definitions follow.
#
namespace :passenger do
	desc "Restarts a Passenger instance on the server."
	task :restart, :roles => :app, :except => { :no_release => true } do
		run "touch #{current_path}/tmp/restart.txt"
	end
end

# Overriding recipe tasks that are included with Capistrano.
namespace :deploy do
	task :default do
		update
		migrate
		restart
	end
	
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

# Custom tasks, written to deploy this particular application correctly.
namespace :deploy do
	desc 'Skips migrations if this is a cold deployment'
	task :load_schema, :roles => :app do
		run "cd #{current_path}; rake db:schema:load"
		run "cd #{current_path}; rake db:defaults:load"
	end
end

namespace :host do
	desc 'Copies the uploads directory from the previous deployment'
	task :copy_assets do
		previous_assets = "#{previous_release}/public/assets"
		run "[ -d #{previous_assets} ] " +
		    "&& (echo 'Copying previous assets.' && cp -R #{previous_assets} #{latest_release}/public/) " +
		    "|| echo 'No previous uploads directory. Skipping.'"
	end
	
	desc "Symlinks the database.yml"
	task :link_db_config, :roles => :app do
		run "ln -nfs #{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml"
	end
	
	namespace :rvm do
		desc 'Links necessary RVM configuration files to the target deployment.'
		task :configure, :roles => :app do
			run "ln -nfs #{deploy_to}/shared/.rvmrc #{release_path}/.rvmrc"
		end
	end
end
