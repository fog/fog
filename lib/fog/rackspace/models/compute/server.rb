require 'fog/compute/models/server'

module Fog
  module Compute
    class Rackspace
      class Server < Fog::Compute::Server
        identity :id

        attribute :addresses
        attribute :flavor_id,   :aliases => 'flavorId', :type => :integer
        attribute :host_id,     :aliases => 'hostId'
        attribute :image_id,    :aliases => 'imageId',  :type => :integer
        attribute :metadata
        attribute :name
        attribute :personality
        attribute :progress
        attribute :state,       :aliases => 'status'

        attr_reader :password

        def initialize(attributes={})
          self.flavor_id  ||= 1  # 256 server
          self.image_id   ||= 49 # Ubuntu 10.04 LTS 64bit
          super
        end

        def destroy
          requires :id
          service.delete_server(id)
          true
        end

        def flavor
          requires :flavor_id
          service.flavors.get(flavor_id)
        end

        def image
          requires :image_id
          service.images.get(image_id)
        end

        def images
          requires :id
          service.images(:server => self)
        end

        def private_ip_address
          addresses['private'].first
        end

        def public_ip_address
          addresses['public'].first
        end

        def ready?
          self.state == 'ACTIVE'
        end

        def reboot(type = 'SOFT')
          requires :id
          service.reboot_server(id, type)
          true
        end

        def save(options = {})
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if persisted?
          requires :flavor_id, :image_id
          options = {
            'metadata'    => metadata,
            'name'        => name,
            'personality' => personality
          }
          options = options.reject {|key, value| value.nil?}
          data = service.create_server(flavor_id, image_id, options)
          merge_attributes(data.body['server'])
          true
        end

        def setup(credentials = {})
          requires :ssh_ip_address, :identity, :public_key, :username
          Fog::SSH.new(ssh_ip_address, username, credentials).run([
            %{mkdir .ssh},
            %{echo "#{public_key}" >> ~/.ssh/authorized_keys},
            %{passwd -l #{username}},
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
