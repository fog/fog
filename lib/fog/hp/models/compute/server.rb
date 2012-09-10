require 'fog/compute/models/server'

module Fog
  module Compute
    class HP

      class Server < Fog::Compute::Server

        identity :id

        attribute :addresses
        attribute :flavor
        attribute :host_id,     :aliases => 'hostId'
        attribute :image
        attribute :metadata
        attribute :name
        attribute :personality
        attribute :progress
        attribute :accessIPv4
        attribute :accessIPv6
        attribute :state,       :aliases => 'status'
        attribute :created_at,  :aliases => 'created'
        attribute :updated_at,  :aliases => 'updated'
        attribute :tenant_id
        attribute :user_id
        attribute :key_name
        # these are implemented as methods
        attribute :image_id
        attribute :flavor_id
        attribute :private_ip_address
        attribute :public_ip_address

        attr_reader :password
        attr_writer :private_key, :private_key_path, :public_key, :public_key_path, :username, :image_id, :flavor_id

        def initialize(attributes = {})
          # assign these attributes first to prevent race condition with new_record?
          self.security_groups = attributes.delete(:security_groups)
          self.min_count = attributes.delete(:min_count)
          self.max_count = attributes.delete(:max_count)
          super
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

        def key_pair
          requires :key_name

          connection.key_pairs.get(key_name)
        end

        def key_pair=(new_keypair)
          self.key_name = new_keypair && new_keypair.name
        end

        def private_ip_address
          addr = addresses.nil? ? nil : addresses.fetch('private', []).first
          addr["addr"] if addr
        end

        def private_key_path
          @private_key_path ||= Fog.credentials[:private_key_path]
          @private_key_path &&= File.expand_path(@private_key_path)
        end

        def private_key
          @private_key ||= private_key_path && File.read(private_key_path)
        end

        def public_ip_address
          # FIX: Both the private and public ips are bundled under "private" network name
          # So hack to get to the public ip address
          if !addresses.nil?
            addr = addresses.fetch('private', [])
            # if we have more than 1 address, then the return the second address which is public
            if addr.count > 1
              addr[1]["addr"]
            else
              nil
            end
          else
            nil
          end
        end

        def public_key_path
          @public_key_path ||= Fog.credentials[:public_key_path]
          @public_key_path &&= File.expand_path(@public_key_path)
        end

        def public_key
          @public_key ||= public_key_path && File.read(public_key_path)
        end

        def image_id
          @image_id ||= (image.nil? ? nil : image["id"])
        end

        def image_id=(new_image_id)
          @image_id = new_image_id
        end

        def flavor_id
          @flavor_id ||= (flavor.nil? ? nil : flavor["id"])
        end

        def flavor_id=(new_flavor_id)
          @flavor_id = new_flavor_id
        end

        def min_count=(new_min_count)
          @min_count = new_min_count
        end

        def max_count=(new_max_count)
          @max_count = new_max_count
        end

        def security_groups=(new_security_groups)
          @security_groups = new_security_groups
        end

        def security_groups   
          @security_groups
        end
        
        def ready?
          self.state == 'ACTIVE'
        end

        def change_password(admin_password)
          requires :id
          connection.change_password_server(id, admin_password)
          true
        end

        def reboot(type = 'SOFT')
          requires :id
          connection.reboot_server(id, type)
          true
        end

        def rebuild(image_id, name, admin_pass=nil, metadata=nil, personality=nil)
          requires :id
          connection.rebuild_server(id, image_id, name, admin_pass, metadata, personality)
          true
        end

        def resize(flavor_id)
          requires :id
          connection.resize_server(id, flavor_id)
          true
        end

        def revert_resize
          requires :id
          connection.revert_resized_server(id)
          true
        end

        def confirm_resize
          requires :id
          connection.confirm_resized_server(id)
          true
        end

        def create_image(name, metadata={})
          requires :id
          connection.create_image(id, name, metadata)
        end

        def save
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if identity
          requires :flavor_id, :image_id, :name
          options = {
            'metadata'    => metadata,
            'personality' => personality,
            'accessIPv4'  => accessIPv4,
            'accessIPv6'  => accessIPv6,
            'min_count'   => @min_count,
            'max_count'   => @max_count,
            'key_name'    => key_name,
            'security_groups' => @security_groups
          }
          options = options.reject {|key, value| value.nil?}
          data = connection.create_server(name, flavor_id, image_id, options)
          merge_attributes(data.body['server'])
          true
        end

        def setup(credentials = {})
          requires :public_ip_address, :identity, :public_key, :username
          Fog::SSH.new(public_ip_address, username, credentials).run([
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
