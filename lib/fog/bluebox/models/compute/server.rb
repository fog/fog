require 'fog/compute/models/server'

module Fog
  module Compute
    class Bluebox
      class BlockInstantiationError < StandardError; end

      class Server < Fog::Compute::Server
        identity :id

        attribute :cpu
        attribute :description
        attribute :flavor_id,   :aliases => :product, :squash => 'id'
        attribute :hostname
        attribute :image_id
        attribute :location_id
        attribute :ips
        attribute :memory
        attribute :state,       :aliases => "status"
        attribute :storage
        attribute :template
        attribute :ipv6_only
        attribute :vsh_id

        attr_accessor :hostname, :password, :lb_applications, :lb_services, :lb_backends

        def initialize(attributes={})
          self.flavor_id    ||= '94fd37a7-2606-47f7-84d5-9000deda52ae' # Block 1GB Virtual Server
          self.image_id     ||= 'a8f05200-7638-47d1-8282-2474ef57c4c3' # Scientific Linux 6
          self.location_id  ||= '37c2bd9a-3e81-46c9-b6e2-db44a25cc675' # Seattle, WA
          super
        end

        def destroy
          requires :id
          service.destroy_block(id)
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

        def location
          requires :location_id
          service.locations.get(location_id)
        end

        def private_ip_address
          nil
        end

        def public_ip_address
          if ip = ips.first
            ip['address']
          end
        end

        def ready?
          self.state == 'running'
        end

        def reboot(type = 'SOFT')
          requires :id
          service.reboot_block(id, type)
          true
        end

        def save
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if persisted?
          requires :flavor_id, :image_id, :location_id
          options = {}

          unless persisted?  # new record
            raise(ArgumentError, "password or public_key is required for this operation") if !password && !public_key
            options['ssh_public_key'] = public_key if public_key
            options['password'] = password if @password
          end

          if @lb_backends
            options['lb_backends'] = lb_backends
          elsif @lb_services
            options['lb_services'] = lb_services
          elsif @lb_applications
            options['lb_applications'] = lb_applications
          end

          options['username'] = username
          options['hostname'] = hostname if @hostname
          options['ipv6_only'] = ipv6_only if ipv6_only
          data = service.create_block(flavor_id, image_id, location_id, options)
          merge_attributes(data.body)
          true
        end

        def setup(credentials = {})
          requires :identity, :ips, :public_key, :username
          Fog::SSH.new(ssh_ip_address, username, credentials).run([
            %{mkdir .ssh},
            %{echo "#{public_key}" >> ~/.ssh/authorized_keys},
            %{passwd -l #{username}},
            %{echo "#{Fog::JSON.encode(attributes)}" >> ~/attributes.json}
          ])
        rescue Errno::ECONNREFUSED
          sleep(1)
          retry
        end

        def username
          @username ||= 'deploy'
        end
      end
    end
  end
end
