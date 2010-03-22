class InThreadServer
  def self.rackup(*a)
    server = new(*a)
    server.start
    server
  end

  attr_accessor :port, :port_range, :pre_spawn_callback, :config_ru, :running

  def initialize(config_ru, pre_spawn_callback = nil, port_range = 8000..10000)
    @config_ru, @pre_spawn_callback, @port_range = config_ru, pre_spawn_callback, port_range
  end

  def start
    return if running
    find_port
    pre_spawn
    spawn_server_thread
    wait_for_server
    @running = true
  end

  def stop
    @thread.kill
    @running= false
  end

  def find_port
    return if @port

    @port = @port_range.min

    while(system("lsof -i tcp:#{self.port} > /dev/null")) do
      @port += 1
    end
  end

  def pre_spawn
    pre_spawn_callback.call(self) if pre_spawn_callback
  end

  def spawn_server_thread
    @thread ||= Thread.new {
      begin
        Rack::Server.new(:Port => @port, :config => @config_ru, :server => 'mongrel').start
      rescue
        $stderr.puts "Failed to start server"
        $stderr.puts $!.inspect
        $stderr.puts $!.backtrace
        abort
      end
    }
  end

  def wait_for_server
    loop do
      begin
        Rack::Client.get("http://127.0.0.1:#{@port}/")
        break
      rescue Errno::ECONNREFUSED
        sleep 1
      end
    end
  end
end

class DigestServer < Rack::Auth::Digest::MD5
  def initialize(*)
    super
    self.opaque = '12345'
  end
end
