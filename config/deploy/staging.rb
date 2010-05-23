set :branch, 'master'
set :environment, 'staging'
set :rails_env, 'staging'
set :domain, 'stage.madisonbrass.com'
set :keep_releases, 1
use_madisonbrass

before :deploy, :create_stage_directory
task :create_stage_directory do
	existing_production_site = "/home/#{user}/sites/madisonbrass.com"
	run "[ -d #{existing_production_site} ] " +
	    "&& (echo 'Cloning existing production site.' && rm -Rf #{deploy_to} && cp -R #{existing_production_site} #{deploy_to}) " +
	    "||  echo 'No existing production site; staging from scratch!'"
end
