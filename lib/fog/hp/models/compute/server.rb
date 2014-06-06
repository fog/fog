require 'fog/compute/models/server'
require 'fog/hp/models/compute/metadata'

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
        attribute :security_groups
        attribute :config_drive
        attribute :user_data_encoded
        # these are implemented as methods
        attribute :image_id
        attribute :flavor_id
        attribute :private_ip_address
        attribute :public_ip_address

        attr_reader :password
        attr_writer :private_key, :private_key_path
        attr_writer :public_key, :public_key_path
        attr_writer :username, :image_id, :flavor_id, :network_name

        def initialize(attributes = {})
          # assign these attributes first to prevent race condition with new_record?
          self.min_count = attributes.delete(:min_count)
          self.max_count = attributes.delete(:max_count)
          self.block_device_mapping = attributes.delete(:block_device_mapping)
          super
        end

        def metadata
          @metadata ||= begin
            Fog::Compute::HP::Metadata.new({
              :service => service,
              :parent => self
            })
          end
        end

        def metadata=(new_metadata={})
          metas = []
          new_metadata.each_pair {|k,v| metas << {"key" => k, "value" => v} }
          metadata.load(metas)
        end

        def user_data=(ascii_userdata)
          self.user_data_encoded = [ascii_userdata].pack('m')  # same as Base64.encode64
        end

        def console_output(num_lines)
          requires :id
          service.get_console_output(id, num_lines)
        end

        def vnc_console_url(type='novnc')
          requires :id
          if resp = service.get_vnc_console(id, type).body
            resp['console']['url']
          else
            nil
          end
        end

        def destroy
          requires :id
          service.delete_server(id)
          true
        end

        def key_pair
          requires :key_name

          service.key_pairs.get(key_name)
        end

        def key_pair=(new_keypair)
          self.key_name = new_keypair && new_keypair.name
        end

        def network_name
          @network_name ||= "private"
        end

        def private_ip_addresses
          return nil if addresses.nil?
          addr = []
          addresses.each { |key, value|
            ipaddr = value.first
            addr << ipaddr["addr"] unless ipaddr.nil?
          }
          addr
        end

        def private_ip_address
          private_ip_addresses.first
        end

        def private_key_path
          @private_key_path ||= Fog.credentials[:private_key_path]
          @private_key_path &&= File.expand_path(@private_key_path)
        end

        def private_key
          @private_key ||= private_key_path && File.read(private_key_path)
        end

        def public_ip_addresses
          return nil if addresses.nil?
          addr = []
          addresses.each { |key, value|
            if value.count > 1
              value = value.dup
              value.delete_at(0)
              value.each { |ipaddr|
                addr << ipaddr["addr"]
              }
            end
          }
          addr
        end

        def public_ip_address
          public_ip_addresses.first
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

        def block_device_mapping=(new_block_device_mapping)
          @block_device_mapping = new_block_device_mapping
        end

        def ready?
          self.state == 'ACTIVE'
        end

        def change_password(admin_password)
          requires :id
          service.change_password_server(id, admin_password)
          true
        end

        def windows_password()
          requires :id
          service.get_windows_password(id)
        end

        def reboot(type = 'SOFT')
          requires :id
          service.reboot_server(id, type)
          true
        end

        def rebuild(image_id, name, admin_pass=nil, metadata=nil, personality=nil)
          requires :id
          service.rebuild_server(id, image_id, name, admin_pass, metadata, personality)
          true
        end

        def resize(flavor_id)
          requires :id
          service.resize_server(id, flavor_id)
          true
        end

        def revert_resize
          requires :id
          service.revert_resized_server(id)
          true
        end

        def confirm_resize
          requires :id
          service.confirm_resized_server(id)
          true
        end

        def create_image(name, metadata={})
          requires :id
          service.create_image(id, name, metadata)
        end

        def volume_attachments
          requires :id
          if vols = service.list_server_volumes(id).body
            vols["volumeAttachments"]
          end
        end

        def save
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if persisted?
          requires :flavor_id, :name
          meta_hash = {}
          metadata.each { |meta| meta_hash.store(meta.key, meta.value) }
          options = {
            'metadata'        => meta_hash,
            'personality'     => personality,
            'accessIPv4'      => accessIPv4,
            'accessIPv6'      => accessIPv6,
            'min_count'       => @min_count,
            'max_count'       => @max_count,
            'key_name'        => key_name,
            'security_groups' => security_groups,
            'config_drive'    => config_drive,
            'user_data'       => user_data_encoded
          }
          options = options.reject {|key, value| value.nil?}
          # either create a regular server or a persistent server based on input
          if image_id
            # create a regular server using the image
            data = service.create_server(name, flavor_id, image_id, options)
          elsif image_id.nil? && !@block_device_mapping.nil? && !@block_device_mapping.empty?
            # create a persistent server using the bootable volume in the block_device_mapping
            data = service.create_persistent_server(name, flavor_id, @block_device_mapping, options)
          end
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
