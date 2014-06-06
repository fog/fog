require 'fog/compute/models/server'

module Fog
  module Compute
    class GoGrid
      class BlockInstantiationError < StandardError; end

      class Server < Fog::Compute::Server
        extend Fog::Deprecation
        deprecate(:ip, :public_ip_address)

        identity :id

        attribute :name
        attribute :image_id     # id or name
        attribute :public_ip_address, :aliases => 'ip', :squash => 'ip'
        attribute :memory       # server.ram
        attribute :state
        attribute :description  # Optional
        attribute :sandbox      # Optional. Default: False

        def initialize(attributes={})
          image_id ||= 'ubuntu_10_04_LTS_64_base' # Ubuntu 10.04 LTS 64bit
          super
        end

        def destroy
          requires :id
          service.grid_server_delete(id)
          true
        end

        def image
          requires :image_id
          service.grid_image_get(:image => image_id)
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
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if persisted?
          requires :name, :image_id, :memory, :public_ip_address
          options = {
            'isSandbox'   => sandbox,
            'image'       => image_id
          }
          options = options.reject {|key, value| value.nil?}
          data = service.grid_server_add(image, public_ip_address, name, memory, options)
          merge_attributes(data.body)
          true
        end

        def setup(credentials = {})
          requires :identity, :ssh_ip_address, :public_key, :username
          Fog::SSH.new(ssh_ip_address, username, credentials).run([
            %{mkdir .ssh},
            %{echo "#{public_key}" >> ~/.ssh/authorized_keys},
            %{passwd -l root},
            %{echo "#{Fog::JSON.encode(attributes)}" >> ~/attributes.json},
            %{echo "#{Fog::JSON.encode(metadata)}" >> ~/metadata.json}
          ])
        rescue Errno::ECONNREFUSED
          sleep(1)
          retry
        end

        private

        def adminPass=(new_admin_pass)
          @password = new_admin_pass
        end
      end
    end
  end
end
