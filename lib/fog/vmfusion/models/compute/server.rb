require 'fog/core/model'

module Fog
  module Compute
    class Vmfusion

      class Server < Fog::Model

        identity :name

        attribute :name
        attribute :state

        attr_accessor :password
        attr_writer   :private_key, :private_key_path, :public_key, :public_key_path, :username

        def initalize(attributes={})
        end

        def save
          raise Fog::Errors::Error.new('Creating a new vm is not yet supported')
        end

        def clone(name)
          requires :raw

          ::Fission::VM.clone(@raw.name,name)
          return connection.servers.get(name)
        end

        def destroy(options={ :force => false})
          requires :raw

          if state=="running"
            if options[:force]
              @raw.stop
            end
          end

          ::Fission::VM.delete @raw.name
        end

        def start
          requires :raw

          unless state=="running"
            @raw.start
            return true
          else
            return false
          end
        end

        def stop
          requires :raw

          if state=="running"
            @raw.stop
            return true
          else
            return false
          end
        end

        def reboot
          requires :raw
          if state=="running"
            @raw.stop
            wait_for { state!="running"}
            @raw.start
            return true
          else
            return false
          end
        end

        def halt
          requires :raw
          if state=="running"
            @raw.halt
            return true
          else
            return false
          end

        end

        def poweroff
          requires :raw
          halt
        end

        def shutdown
          requires :raw
          stop
        end

        def resume
          requires :raw
          @raw.resume
        end

        def suspend
          requires :raw
          @raw.suspend
        end

        def state
          requires :raw
          @raw.state
        end

        def ready?
          state == "running"
        end

        def private_ip_address
          ip_address(:private)
        end

        def public_ip_address
          ip_address(:public)
        end


        def username
          @username ||= 'root'
        end

        def ssh(commands)
          requires :public_ip_address, :username

          #requires :password, :private_key
          ssh_options={}
          ssh_options[:password] = password unless password.nil?
          ssh_options[:key_data] = [private_key] if private_key

          Fog::SSH.new(public_ip_address, @username, ssh_options).run(commands)

        end

        def scp(local_path, remote_path, upload_options = {})
          requires :public_ip_address, :username

          scp_options = {}
          scp_options[:password] = password unless self.password.nil?
          scp_options[:key_data] = [private_key] if self.private_key

          Fog::SCP.new(public_ip_address, username, scp_options).upload(local_path, remote_path, upload_options)
        end

        # Sets up a new key
        def setup(credentials = {})
          requires :public_key, :public_ip_address, :username

          credentials[:password] = password unless self.password.nil?
          credentails[:key_data] = [private_key] if self.private_key

          commands = [
            %{mkdir .ssh},
          ]
          if public_key
            commands << %{echo "#{public_key}" >> ~/.ssh/authorized_keys}
          end

          # wait for domain to be ready
          Timeout::timeout(360) do
            begin
              Timeout::timeout(8) do
                Fog::SSH.new(public_ip_address, username, credentials.merge(:timeout => 4)).run('pwd')
              end
            rescue Errno::ECONNREFUSED
              sleep(2)
              retry
            rescue Net::SSH::AuthenticationFailed, Timeout::Error
              retry
            end
          end
          Fog::SSH.new(public_ip_address, username, credentials).run(commands)
        end

        def private_key_path
          @private_key_path ||= Fog.credentials[:private_key_path]
          @private_key_path &&= File.expand_path(@private_key_path)
        end

        def private_key
          @private_key ||= private_key_path && File.read(private_key_path)
        end

        def public_key_path
          @public_key_path ||= Fog.credentials[:public_key_path]
          @public_key_path &&= File.expand_path(@public_key_path)
        end

        def public_key
          @public_key ||= public_key_path && File.read(public_key_path)
        end

        private
        def ip_address(key)
          @raw.ip_address
        end

        def raw
          @raw
        end

        def raw=(new_raw)
          @raw = new_raw

          raw_attributes = {
            :name => new_raw.name,
            :state => new_raw.state
          }

          merge_attributes(raw_attributes)
        end

      end
    end
  end
end
