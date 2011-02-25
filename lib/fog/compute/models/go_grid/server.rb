require 'fog/core/model'

module Fog
  module GoGrid
    class Compute

      class BlockInstantiationError < StandardError; end

      class Server < Fog::Model
        extend Fog::Deprecation
        deprecate(:ip, :public_ip_address)

        identity :id

        attribute :name
        attribute :image_id     # id or name
        attribute :public_ip_address, :aliases => 'ip'
        attribute :memory       # server.ram
        attribute :state
        attribute :description  # Optional
        attribute :sandbox      # Optional. Default: False

        def initialize(attributes={})
          super
        end

        def destroy
          requires :id
          connection.grid_server_delete(id)
          true
        end

        def image
          requires :image_id
          connection.grid_image_get(:image => image_id)
        end

        def private_ip_address
          nil
        end

        def ready?
          @state && @state["name"] == 'On'
        end

        def reload
          requires :name
          begin
            if data = collection.get(name)
              new_attributes = data.attributes
              merge_attributes(new_attributes)
              self
            end
          rescue Excon::Errors::BadRequest
            false
          end
        end

        def save
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if identity
          requires :name, :image_id, :ip, :memory
          options = {
            'isSandbox'   => sandbox,
            'image'       => image_id
          }
          options = options.reject {|key, value| value.nil?}
          data = connection.grid_server_add(image, ip, name, memory, options)
          merge_attributes(data.body)
          true
        end

        def ssh(commands)
          requires :ip, :identity, :username

          options = {}
          options[:key_data] = [private_key] if private_key
          Fog::SSH.new(ip['ip'], username, options).run(commands)
        end

        def scp(local_path, remote_path)
          requires :ip, :username

          options = {}
          options[:key_data] = [private_key] if private_key
          Fog::SCP.new(ip['ip'], username, options).upload(local_path, remote_path)
        end

        def setup(credentials = {})
          requires :ip, :identity, :public_key, :username
          Fog::SSH.new(ip['ip'], username, credentials).run([
            %{mkdir .ssh},
            %{echo "#{public_key}" >> ~/.ssh/authorized_keys},
            %{passwd -l root},
            %{echo "#{attributes.to_json}" >> ~/attributes.json},
            %{echo "#{metadata.to_json}" >> ~/metadata.json}
          ])
        rescue Errno::ECONNREFUSED
          sleep(1)
          retry
        end

        def username
          @username ||= 'root'
        end

        private

        def adminPass=(new_admin_pass)
          @password = new_admin_pass
        end

      end

    end

  end
end
