# config valid for current version and patch releases of Capistrano
lock "~> 3.11.0"

set :application, "profiler_life"
set :repo_url, "git@github.com:triple2digital-jeff/triple2digital-jeff.git"


set :rbenv_type, :system # or :system, depends on your rbenv setup
set :rbenv_ruby, '2.5.1'
set :rbenv_custom_path, '/home/ubuntu/.rbenv/'

# in case you want to set ruby version from the file:
# set :rbenv_ruby, File.read('.ruby-version').strip

set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value



#
# set :ssh_options, {
#     #keys: %w(~/.ssh/aws-ec2.pem),
#     forward_agent: true
#     #  auth_methods: %w(password)
# }

set :ssh_options,     { forward_agent: true, keys: "~/markmate/ProKey.pem" }

# set ssh_options: {
#     keys: %w(/home/rashidromi/Downloads/ProfilerDevelopment.pem),
#     forward_agent: false,
#     # auth_methods: %w(publickey)
# }

# set :ssh_options, { forward_agent: true, user: fetch(:user), keys: %w(/home/rashidromi/Downloads/ProfilerDevelopment.pem) }

# Default branch is :master
ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call



set :linked_files, %w{config/database.yml config/secrets.yml}
set :bundle_binstubs, nil
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/headshots}

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

set :branch, 'main'


set :scm,           :git
set :format,        :pretty
set :log_level,     :debug
set :keep_releases, 5


set :pty,             true

# set :puma_bind,       "unix://#{shared_path}/tmp/sockets/puma.sock"
# set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
# set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
# set :puma_access_log, "#{release_path}/log/puma.error.log"
# set :puma_error_log,  "#{release_path}/log/puma.access.log"
# set :ssh_options,     { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub) }
# set :puma_preload_app, true
# set :puma_worker_timeout, nil
# set :puma_init_active_record
#
# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
# set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

# namespace :puma do
#   desc 'Create Directories for Puma Pids and Socket'
#   task :make_dirs do
#     on roles(:app) do
#       execute "mkdir #{shared_path}/tmp/sockets -p"
#       execute "mkdir #{shared_path}/tmp/pids -p"
#     end
#   end
#
#   before :make_dirs
# end
#
#


namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :touch, release_path.join('tmp/restart.txt')
      # execute 'sudo', '/etc/init.d/hcm', 'restart'
    end
  end
  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end


end

# namespace :deploy do
#   desc "Make sure local git is in sync with remote."
#   task :check_revision do
#     on roles(:app) do
#       unless `git rev-parse HEAD` == `git rev-parse origin/master`
#         puts "WARNING: HEAD is not the same as origin/master"
#         puts "Run `git push` to sync changes."
#         exit
#       end
#     end
#   end
#
#   desc 'Initial Deploy'
#   task :initial do
#     on roles(:app) do
#       before 'deploy:restart'
#       invoke 'deploy'
#     end
#   end
#
#   desc 'Restart application'
#   task :restart do
#     on roles(:app), in: :sequence, wait: 5 do
#       invoke 'puma:restart'
#     end
#   end
#
#   before :starting,     :check_revision
#   after  :finishing,    :compile_assets
#   after  :finishing,    :cleanup
#   after  :finishing,    :restart
# end

# ps aux | grep puma    # Get puma pid
# kill -s SIGUSR2 pid   # Restart puma
# kill -s SIGTERM pid   # Stop puma





