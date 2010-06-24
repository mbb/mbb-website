set :branch, 'master'
set :environment, 'staging'
set :rails_env, 'staging'
set :domain, 'stage.madisonbrass.com'
set :keep_releases, 1
use_madisonbrass

before :deploy, 'stage:files'
before 'deploy:migrate', 'stage:database'

namespace :stage do
	desc "Overwrite the whole stage database with a copy of the production database."
	task :database do
		get("#{shared_path}/config/database.yml", "tmp/database.remote.yml")
		config = YAML.load(IO.read("tmp/database.remote.yml"))
		File.delete('tmp/database.remote.yml')
		staging_config = config["staging"]
		production_config = config["production"]
		
		unless staging_config["adapter"] == "mysql" and
		       production_config["adapter"] == "mysql"
			raise "This task works only on mysql"
		end
		
		to_stage          = "mysql #{staging_config["host"]} -u #{staging_config["username"]} -p#{staging_config["password"]} #{staging_config["database"]}"
		drop_stage_tables = "mysqldump #{staging_config["host"]} -u #{staging_config['username']} -p#{staging_config['password']} --add-drop-table --no-data #{staging_config["database"]} | grep ^DROP"
		dump_production   = "mysqldump #{production_config["host"]} -u #{production_config["username"]} -p#{production_config["password"]} #{production_config["database"]}"
		
		print "(dropping existing staged tables) ..."
		STDOUT.flush
		run "#{drop_stage_tables} | #{to_stage}"
		puts 'done.'
		
		print "(copying the production database) ..."
		STDOUT.flush
		run "#{dump_production} | #{to_stage}"
		puts "done."
	end
	
	desc 'Copy all the files for the production site to the stage site.'
	task :files do
		existing_production_site = "/home/#{user}/sites/madisonbrass.com"
		run "[ -d #{existing_production_site} ] " +
		    "&& (echo 'Cloning existing production site.' && rm -Rf #{deploy_to} && cp -R #{existing_production_site} #{deploy_to}) " +
		    "|| echo 'No existing production site; staging from scratch!'"
	end
end

desc 'Tear down all staged files.'
task :teardown do
	run "[ -d #{deploy_to} ] " +
	    "&& (echo 'Tearing down staged files.' && rm -Rf #{deploy_to}) " +
	    "|| (echo 'Nothing to tear down!')"
end
