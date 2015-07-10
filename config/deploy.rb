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

before 'deploy:setup', 'rvm:install_rvm', 'rvm:install_ruby' 
after 'deploy:update_code', :roles => :app do
  # Здесь для примера вставлен только один конфиг с приватными данными - database.yml. Обычно для таких вещей создают папку /srv/myapp/shared/config и кладут файлы туда. При каждом деплое создаются ссылки на них в нужные места приложения.
  run "rm -f #{current_release}/config/#{file}.yml"
  run "ln -s #{deploy_to}/shared/config/#{file}.yml #{current_release}/config/#{file}.yml"
end

after 'deploy:published', 'deploy:restart'

namespace :deploy do
	desc 'Restart application'
	task :restart do
	  on roles(:app), in: :sequence, wait: 5 do
	    execute 'service thin restart' 
	  end
	end
end
