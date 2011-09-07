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
        attribute :ips
        attribute :memory
        attribute :state,       :aliases => "status"
        attribute :storage
        attribute :template

        attr_accessor :password, :lb_applications, :lb_services, :lb_backends
        attr_writer :private_key, :private_key_path, :public_key, :public_key_path, :username

        def initialize(attributes={})
          self.flavor_id  ||= '94fd37a7-2606-47f7-84d5-9000deda52ae' # Block 1GB Virtual Server
          self.image_id   ||= '03807e08-a13d-44e4-b011-ebec7ef2c928' # Ubuntu LTS 10.04 64bit
          super
        end

        def destroy
          requires :id
          connection.destroy_block(id)
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
          ips.first
        end

        def public_key_path
          @public_key_path ||= Fog.credentials[:public_key_path]
          @public_key_path &&= File.expand_path(@public_key_path)
        end

        def public_key
          @public_key ||= public_key_path && File.read(public_key_path)
        end

        def ready?
          self.state == 'running'
        end

        def reboot(type = 'SOFT')
          requires :id
          connection.reboot_block(id, type)
          true
        end

        def save
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if identity
          requires :flavor_id, :image_id
          options = {}

          if identity.nil?  # new record
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
          data = connection.create_block(flavor_id, image_id, options)
          merge_attributes(data.body)
          true
        end

        def setup(credentials = {})
          requires :identity, :ips, :public_key, :username
          Fog::SSH.new(public_ip_address, username, credentials).run([
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
          @username ||= 'deploy'
        end

      end

    end
  end
end
