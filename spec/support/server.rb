require 'httpclient'

module ServerHelpers

  def server_request(path)
    HTTPClient.get("http://127.0.0.1:3068#{path}")
  end

  class << self
    def init
      at_exit do
        ServerHelpers.stop_server
      end
    end

    def start_server(options = {})
      port = options[:port] || 3068

      puts "Starting server on port: #{port}"

      repo_root = File.expand_path("../../..", __FILE__)

      extra_env = options[:extra_env] || {}
      env = {
        "CONTENT_STORE_ADDR"  => ":#{port}",
      }.merge(extra_env)

      if ENV['USE_COMPILED_APPLICATION']
        command = %w(./content-store)
      else
        command = %w(make run)
      end

      spawn_args = {
        :chdir => repo_root,
        :pgroup => true
      }
      spawn_args.merge!(:out => "/dev/null", :err => "/dev/null") unless ENV['DEBUG_SERVER']

      pid = spawn(env, *command, spawn_args)

      retries = 0
      begin
        s = TCPSocket.new("localhost", port)
      rescue Errno::ECONNREFUSED
        if retries < 20
          retries += 1
          sleep 0.1
          retry
        else
          raise
        end
      ensure
        s.close if s
      end
      @server_pid = pid
      pid
    end

    def stop_server
      if @server_pid
        Process.kill("-INT", @server_pid)
        Process.wait(@server_pid)
        @server_pid = nil
      end
    end
  end
end

RSpec.configuration.include(ServerHelpers)
RSpec.configuration.before(:suite) do
  ServerHelpers.init
  ServerHelpers.start_server
end
