cpu_count = `cat /proc/cpuinfo | grep processor | wc -l`.to_i
workers cpu_count

threads 20, 20

app_dir = "/opt/app"

rails_env = "production"
environment rails_env

bind "unix:///tmp/puma.sock"

pidfile "/tmp/puma.pid"
state_path "/tmp/puma.state"
activate_control_app

stdout_redirect '/dev/stdout', '/dev/stderr', true

on_worker_boot do

end

before_fork do
  require "puma_worker_killer"

  free_memory_mb = `cat /proc/meminfo | grep MemAvailable`.gsub(/.*:/, "").to_i / 1024

  PumaWorkerKiller.config do |config|
    config.ram           = free_memory_mb
    config.frequency     = 60
    config.percent_usage = 0.98
    config.rolling_restart_frequency = 3600
    config.reaper_status_logs = true
  end

  PumaWorkerKiller.start
end
