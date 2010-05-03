module Fog
  module SSH

    def self.new(address, username, options = {})
      unless options[:keys] || options[:password]
        raise ArgumentError.new(':keys or :password are required to initialize SSH')
      end
      if Fog.mocking?
        Fog::SSH::Mock.new(address, username, options)
      else
        Fog::SSH::Real.new(address, username, options)
      end
    end

    def self.reset_data(keys=Mock.data.keys)
      Mock.reset_data(keys)
    end

    class Mock

      def self.data
        @data ||= Hash.new do |hash, key|
          hash[key] = {}
        end
      end

      def initialize(address, username, options)
        @address  = address
        @username = username
        @options  = options
      end

      def run(commands)
        raise MockNotImplemented.new("Contributions welcome!")
      end

    end

    class Real

      def initialize(address, username, options)
        @address  = address
        @username = username
        @options  = options.merge!(:paranoid => false)
      end

      def run(commands)
        commands = [*commands]
        results  = []
        begin
          Net::SSH.start(@address, @username, @options) do |ssh|
            commands.each do |command|
              ssh.open_channel do |channel|
                sudoable_command  = command.sub(/^sudo/, %{sudo -p 'fog sudo password:'})
                escaped_command   = sudoable_command.sub(/'/, %{'"'"'})
                channel.request_pty
                result = Result.new(command)
                channel.exec(%{bash -lc '#{escaped_command}'}) do |channel, success|
                  unless success
                    raise "Could not execute command: #{command.inspect}"
                  end

                  channel.on_data do |channel, data|
                    result.stdout << data
                  end

                  channel.on_extended_data do |channel, type, data|
                    next unless type == 1
                    result.stderr << data
                  end

                  channel.on_request('exit-status') do |channel, data|
                    result.status = data.read_long
                  end

                  channel.on_request('exit-signal') do |channel, data|
                    result.status = 255
                  end
                end
                results << result
              end
              ssh.loop
            end
          end
        rescue Net::SSH::HostKeyMismatch => exception
          exception.remember_host!
          sleep 0.2
          retry
        end
        results
      end

    end

    class Result

      attr_accessor :command, :stderr, :stdout, :status

      def initialize(command)
        @command = command
        @stderr = ''
        @stdout = ''
      end

    end

  end
end
