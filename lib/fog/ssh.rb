module Fog

  class SSH

    def initialize(address, username, options = {})
      unless options[:keys] || options[:password]
        raise ArgumentError.new(':keys or :password are required to initialize SSH')
      end
      @address  = address
      @username = username
      @options  = options.merge!(:paranoid => false)
    end

    def run(commands)
      commands = [*commands]
      results = []
      Net::SSH.start(@address, @username, @options) do |ssh|
        commands.each do |command|
          result = { :command => command }
          ssh.exec!(command) do |channel, stream, data|
            result[stream] = data
          end
          results << result
        end
      end
      results
    end

  end

end
