require 'fog/compute/models/server'
require 'fog/openstack/models/compute/metadata'

module Fog
  module Compute
    class OpenStack

      class Server < Fog::Compute::Server

        identity :id

        attribute :addresses
        attribute :flavor
        attribute :host_id,     :aliases => 'hostId'
        attribute :image
        attribute :metadata
        attribute :links
        attribute :name
        attribute :personality
        attribute :progress
        attribute :accessIPv4
        attribute :accessIPv6
        attribute :availability_zone
        attribute :state,       :aliases => 'status'

        attr_reader :password
        attr_writer :private_key, :private_key_path, :public_key, :public_key_path, :username, :image_ref, :flavor_ref

        def initialize(attributes={})
          @connection = attributes[:connection]
          attributes[:metadata] = {}
          super
        end

        def metadata
          @metadata ||= begin
            Fog::Compute::OpenStack::Metadata.new({
              :connection => connection,
              :parent => self
            })
          end
        end

        def metadata=(new_metadata={})
          metas = []
          new_metadata.each_pair {|k,v| metas << {"key" => k, "value" => v} }
          metadata.load(metas)
        end

        def destroy
          requires :id
          connection.delete_server(id)
          true
        end

        def images
          requires :id
          connection.images(:server => self)
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
          addresses['public'].first
        end

        def public_key_path
          @public_key_path ||= Fog.credentials[:public_key_path]
          @public_key_path &&= File.expand_path(@public_key_path)
        end

        def public_key
          @public_key ||= public_key_path && File.read(public_key_path)
        end

        def image_ref
          @image_ref
        end

        def image_ref=(new_image_ref)
          @image_ref = new_image_ref
        end

        def flavor_ref
          @flavor_ref
        end

        def flavor_ref=(new_flavor_ref)
          @flavor_ref = new_flavor_ref
        end

        def ready?
          self.state == 'ACTIVE'
        end

        def change_password(admin_password)
          requires :id
          connection.change_password_server(id, admin_password)
          true
        end

        def rebuild(image_ref, name, admin_pass=nil, metadata=nil, personality=nil)
          requires :id
          connection.rebuild_server(id, image_ref, name, admin_pass, metadata, personality)
          true
        end

        def resize(flavor_ref)
          requires :id
          connection.resize_server(id, flavor_ref)
          true
        end

        def revert_resize
          requires :id
          connection.revert_resize_server(id)
          true
        end

        def confirm_resize
          requires :id
          connection.confirm_resize_server(id)
          true
        end

        def reboot(type = 'SOFT')
          requires :id
          connection.reboot_server(id, type)
          true
        end

        def create_image(name, metadata={})
          requires :id
          connection.create_image(id, name, metadata)
        end

        def save
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if identity
          requires :flavor_ref, :image_ref, :name
          meta_hash = {}
          metadata.each { |meta| meta_hash.store(meta.key, meta.value) }
          options = {
            'metadata'    => meta_hash,
            'personality' => personality,
            'accessIPv4' => accessIPv4,
            'accessIPv6' => accessIPv6,
            'availability_zone' => availability_zone
          }
          options = options.reject {|key, value| value.nil?}
          data = connection.create_server(name, image_ref, flavor_ref, options)
          merge_attributes(data.body['server'])
          true
        end

        def setup(credentials = {})
          requires :public_ip_address, :identity, :public_key, :username
          Fog::SSH.new(public_ip_address, username, credentials).run([
            %{mkdir .ssh},
            %{echo "#{public_key}" >> ~/.ssh/authorized_keys},
            %{passwd -l #{username}},
            %{echo "#{MultiJson.encode(attributes)}" >> ~/attributes.json},
            %{echo "#{MultiJson.encode(metadata)}" >> ~/metadata.json}
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
