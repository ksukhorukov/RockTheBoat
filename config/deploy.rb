# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'RockTheBoat'
set :repo_url, 'git@github.com:ksukhorukov/RockTheBoat.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
 set :deploy_to, '/var/www/rocktheboat'

# Default value for :scm is :git
 set :scm, :git

 set :rvm_ruby_version, 'ruby-2.2.1@rocktheboat'

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

set :linked_files, %w{config/database.yml config/secrets.yml}

after 'deploy:published', 'deploy:restart'
after 'deploy:published', 'deploy:create_symlinkt'

namespace :deploy do

	desc 'Restart application'
	task :restart do
	  on roles(:app), in: :sequence, wait: 5 do
	    execute 'service thin restart' 
	  end
	end

	task :create_symlink do 
		on roles(:app) do 
			linked_files.each do |filename|
				run "ln -s #{deploy_to}/shared/#{filename} #{current_release}/#{filename}"
			end
		end
	end

end


