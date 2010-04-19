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
          ssh.open_channel do |channel|
            channel.request_pty
            result = { :command => command }
            channel.exec(command.sub(/^sudo/, %q{sudo -p 'fog sudo password:'})) do |channel, success|
              channel.on_data do |channel, data|
                if data.strip == 'fog sudo password:'
                  channel.send_data("#{@options[:password]}\n")
                else
                  result[:data] ||= ''
                  result[:data] << data
                end
              end
            end
            results << result
          end
          ssh.loop
        end
      end
      results
    end

  end

end
