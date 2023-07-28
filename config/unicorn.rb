# 現在のファイルのあるディレクトリ名の絶対パスを基準に(__dir__)、1つ前のディレクトリの絶対パスをapp_pathに格納
app_path = File.expand_path('..', __dir__)

# ワーカー数を指定
worker_processes 1

# Unicornの起動コマンドを実行するディレクトリを指定。
working_directory app_path

listen 3000

# プロセスの停止などに必要なPIDファイルの保存先を指定。
pid "#{app_path}/tmp/pids/unicorn.pid"

# Unicornのエラーログと通常ログの位置を指定。
stderr_path "#{app_path}/log/unicorn.stderr.log"
stdout_path "#{app_path}/log/unicorn.stdout.log"

timeout 600

# 基本的には`true`を指定する。Unicornの再起動時にダウンタイムなしで再起動が行われる。
preload_app true
GC.respond_to?(:copy_on_write_friendly=) && GC.copy_on_write_friendly = true

check_client_connection false

run_once = true

# 再起動時に古いプロセスをkillしてくれる。
before_fork do |server, worker|
  defined?(ActiveRecord::Base) &&
    ActiveRecord::Base.connection.disconnect!

  if run_once
    run_once = false
  end

  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exist?(old_pid) && server.pid != old_pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH => e
      logger.error e
    end
  end
end

after_fork do |_server, _worker|
  defined?(ActiveRecord::Base) && ActiveRecord::Base.establish_connection
end
