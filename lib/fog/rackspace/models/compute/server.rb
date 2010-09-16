require 'fog/model'

module Fog
  module Rackspace
    class Compute

      class Server < Fog::Model

        identity :id

        attribute :addresses
        attribute :flavor_id,   :aliases => 'flavorId'
        attribute :host_id,     :aliases => 'hostId'
        attribute :image_id,    :aliases => 'imageId'
        attribute :metadata
        attribute :name
        attribute :personality
        attribute :progress
        attribute :status

        attr_accessor :password, :private_key_path, :public_key_path, :username

        def initialize(attributes={})
          @flavor_id ||= 1
          super
        end

        def destroy
          requires :id
          connection.delete_server(@id)
          true
        end

        def flavor
          requires :flavor_id
          connection.flavors.get(@flavor_id)
        end

        def image
          requires :image_id
          connection.images.get(@image_id)
        end

        def images
          requires :id
          connection.images(:server => self)
        end

        def ready?
          @status == 'ACTIVE'
        end

        def reboot(type = 'SOFT')
          requires :id
          connection.reboot_server(@id, type)
          true
        end

        def private_key_path
          @private_key_path ||= Fog.credentials[:private_key_path]
        end

        def public_key_path
          @public_key_path ||= Fog.credentials[:public_key_path]
        end

        def save
          requires :flavor_id, :image_id, :name
          options = {
            'metadata'    => @metadata,
            'name'        => @name,
            'personality' => @personality
          }
          options = options.reject {|key, value| value.nil?}
          data = connection.create_server(@flavor_id, @image_id, options)
          merge_attributes(data.body['server'])
          true
        end

        def setup(credentials = {})
          requires :addresses, :identity, :public_key_path, :username
          Fog::SSH.new(addresses['public'].first, username, credentials).run([
            %{mkdir .ssh},
            %{echo "#{File.read(File.expand_path(public_key_path))}" >> ~/.ssh/authorized_keys},
            %{passwd -l root},
            %{echo "#{attributes.to_json}" >> ~/attributes.json},
            %{echo "#{metadata.to_json}" >> ~/metadata.json}
          ])
        rescue Errno::ECONNREFUSED
          sleep(1)
          retry
        end

        def ssh(commands)
          requires :addresses, :identity, :private_key_path, :username
          @ssh ||= Fog::SSH.new(addresses['public'].first, username, :keys => [private_key_path])
          @ssh.run(commands)
        end

        def username
          @username ||= root
        end

        private

        def adminPass=(new_admin_pass)
          @password = new_admin_pass
        end

      end

    end
  end

end
