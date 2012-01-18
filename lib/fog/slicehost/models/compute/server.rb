require 'fog/compute/models/server'

module Fog
  module Compute
    class Slicehost

      class Server < Fog::Compute::Server

        identity :id

        attribute :addresses
        attribute :backup_id,     :aliases => 'backup-id'
        attribute :bandwidth_in,  :aliases => 'bw-in'
        attribute :bandwidth_out, :aliases => 'bw-out'
        attribute :flavor_id,     :aliases => 'flavor-id'
        attribute :image_id,      :aliases => 'image-id'
        attribute :name
        attribute :progress
        attribute :state,         :aliases => 'status'

        attr_accessor :password
        alias_method :'root-password=', :password=
        attr_writer :private_key, :private_key_path, :public_key, :public_key_path, :username

        def initialize(attributes={})
          self.flavor_id  ||= 1  # 256 server
          self.image_id   ||= 49 # Ubuntu 10.04 LTS 64bit
          super
        end

        def destroy
          requires :id
          connection.delete_slice(id)
          true
        end

        def flavor
          requires :flavor_id
          connection.flavors.get(flavor_id)
        end

        def image
          requires :image_id
          connection.images.get(image_id)
        end

        def private_ip_address
          nil
        end

        def private_key_path
          @private_key_path ||= Fog.credentials[:private_key_path]
          @private_key_path &&= File.expand_path(@private_key_path)
        end

        def private_key
          @private_key ||= private_key_path && File.read(private_key_path)
        end

        def public_ip_address
          addresses.first
        end

        def public_key_path
          @public_key_path ||= Fog.credentials[:public_key_path]
          @public_key_path &&= File.expand_path(@public_key_path)
        end

        def public_key
          @public_key ||= public_key_path && File.read(public_key_path)
        end

        def ready?
          self.state == 'active'
        end

        def reboot(type = 'SOFT')
          requires :id
          connection.reboot_slice(id, type)
          true
        end

        def save
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if identity
          requires :flavor_id, :image_id, :name

          data = connection.create_slice(flavor_id, image_id, name)
          merge_attributes(data.body)
          true
        end

        def setup(credentials = {})
          requires :addresses, :identity, :public_key, :username
          Fog::SSH.new(addresses.first, username, credentials).run([
            %{mkdir .ssh},
            %{echo "#{public_key}" >> ~/.ssh/authorized_keys},
            %{passwd -l #{username}},
            %{echo "#{MultiJson.encode(attributes)}" >> ~/attributes.json}
          ])
        rescue Errno::ECONNREFUSED
          sleep(1)
          retry
        end

        def username
          @username ||= 'root'
        end

      end

    end
  end
end
