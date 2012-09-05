require 'fog/compute/models/server'
require 'fog/openstack/models/compute/metadata'

module Fog
  module Compute
    class OpenStack

      class Server < Fog::Compute::Server

        identity :id
        attribute :instance_name, :aliases => 'OS-EXT-SRV-ATTR:instance_name'

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
        attribute :user_data_encoded
        attribute :state,       :aliases => 'status'

        attribute :tenant_id
        attribute :user_id
        attribute :key_name
        attribute :fault
        attribute :os_dcf_disk_config, :aliases => 'OS-DCF:diskConfig'
        attribute :os_ext_srv_attr_host, :aliases => 'OS-EXT-SRV-ATTR:host'
        attribute :os_ext_srv_attr_hypervisor_hostname, :aliases => 'OS-EXT-SRV-ATTR:hypervisor_hostname'
        attribute :os_ext_srv_attr_instance_name, :aliases => 'OS-EXT-SRV-ATTR:instance_name'
        attribute :os_ext_sts_power_state, :aliases => 'OS-EXT-STS:power_state'
        attribute :os_ext_sts_task_state, :aliases => 'OS-EXT-STS:task_state'
        attribute :os_ext_sts_vm_state, :aliases => 'OS-EXT-STS:vm_state'

        attr_reader :password
        attr_writer :private_key, :private_key_path, :public_key, :public_key_path, :username, :image_ref, :flavor_ref


        def initialize(attributes={})
          @connection = attributes[:connection]
          attributes[:metadata] = {}

          self.security_groups = attributes.delete(:security_groups)
          self.min_count = attributes.delete(:min_count)
          self.max_count = attributes.delete(:max_count)

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

        def user_data=(ascii_userdata)
          self.user_data_encoded = [ascii_userdata].pack('m')
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
          if addresses['private']
            #assume only a single private
            return addresses['private'].first
          elsif addresses['internet']
            #assume no private IP means private cloud
            return addresses['internet'].first
          end
        end

        def private_key_path
          @private_key_path ||= Fog.credentials[:private_key_path]
          @private_key_path &&= File.expand_path(@private_key_path)
        end

        def private_key
          @private_key ||= private_key_path && File.read(private_key_path)
        end

        def public_ip_address
          if addresses['public']
            #assume last is either original or assigned from floating IPs
            return addresses['public'].last
          elsif addresses['internet']
            #assume no public IP means private cloud
            return addresses['internet'].first
          end
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
          connection.change_server_password(id, admin_password)
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

        def security_groups=(new_security_groups)
          @security_groups = new_security_groups
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

        def console(log_length = nil)
          requires :id
          connection.get_console_output(id, log_length)
        end

        def migrate
          requires :id
          connection.migrate_server(id)
        end

        def live_migrate(host, block_migration, disk_over_commit)
          requires :id
          connection.live_migrate_server(id, host, block_migration, disk_over_commit)
        end

        def associate_address(floating_ip)
          requires :id
          connection.associate_address id, floating_ip
        end

        def disassociate_address(floating_ip)
          requires :id
          connection.disassociate_address id, floating_ip
        end

        def min_count=(new_min_count)
          @min_count = new_min_count
        end

        def max_count=(new_max_count)
          @max_count = new_max_count
        end

        def networks
          connection.networks(:server => self)
        end

        # TODO: Implement /os-volumes-boot support with 'block_device_mapping'
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
            'availability_zone' => availability_zone,
            'user_data' => user_data_encoded,
            'key_name'    => key_name,
            'security_groups' => @security_groups,
            'min_count'   => @min_count,
            'max_count'   => @max_count,
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
