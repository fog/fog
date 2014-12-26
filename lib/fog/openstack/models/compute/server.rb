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

        # @!attribute [rw] personality
        # @note This attribute is only used for server creation. This field will be nil on subsequent retrievals.
        # @return [Hash] Hash containing data to inject into the file system of the cloud server instance during server creation.
        # @example To inject fog.txt into file system
        #   :personality => [{ :path => '/root/fog.txt',
        #                      :contents => Base64.encode64('Fog was here!')
        #                   }]
        # @see #create
        # @see http://docs.openstack.org/api/openstack-compute/2/content/Server_Personality-d1e2543.html
        attribute :personality
        attribute :progress
        attribute :accessIPv4
        attribute :accessIPv6
        attribute :availability_zone, :aliases => 'OS-EXT-AZ:availability_zone'
        attribute :user_data_encoded
        attribute :state,       :aliases => 'status'
        attribute :created,     :type => :time
        attribute :updated,     :type => :time

        attribute :tenant_id
        attribute :user_id
        attribute :key_name
        attribute :fault
        attribute :config_drive
        attribute :os_dcf_disk_config, :aliases => 'OS-DCF:diskConfig'
        attribute :os_ext_srv_attr_host, :aliases => 'OS-EXT-SRV-ATTR:host'
        attribute :os_ext_srv_attr_hypervisor_hostname, :aliases => 'OS-EXT-SRV-ATTR:hypervisor_hostname'
        attribute :os_ext_srv_attr_instance_name, :aliases => 'OS-EXT-SRV-ATTR:instance_name'
        attribute :os_ext_sts_power_state, :aliases => 'OS-EXT-STS:power_state'
        attribute :os_ext_sts_task_state, :aliases => 'OS-EXT-STS:task_state'
        attribute :os_ext_sts_vm_state, :aliases => 'OS-EXT-STS:vm_state'

        attr_reader :password
        attr_writer :image_ref, :flavor_ref, :nics, :os_scheduler_hints
        attr_accessor :block_device_mapping, :block_device_mapping_v2

        def initialize(attributes={})
          # Old 'connection' is renamed as service and should be used instead
          prepare_service_value(attributes)

          self.security_groups = attributes.delete(:security_groups)
          self.min_count = attributes.delete(:min_count)
          self.max_count = attributes.delete(:max_count)
          self.nics = attributes.delete(:nics)
          self.os_scheduler_hints = attributes.delete(:os_scheduler_hints)
          self.block_device_mapping = attributes.delete(:block_device_mapping)
          self.block_device_mapping_v2 = attributes.delete(:block_device_mapping_v2)

          super
        end

        def metadata
          @metadata ||= begin
            Fog::Compute::OpenStack::Metadata.new({
              :service => service,
              :parent => self
            })
          end
        end

        def metadata=(new_metadata={})
          return unless new_metadata
          metas = []
          new_metadata.each_pair {|k,v| metas << {"key" => k, "value" => v} }
          @metadata = metadata.load(metas)
        end

        def user_data=(ascii_userdata)
          self.user_data_encoded = [ascii_userdata].pack('m')
        end

        def destroy
          requires :id
          service.delete_server(id)
          true
        end

        def images
          requires :id
          service.images(:server => self)
        end

        def all_addresses
          # currently openstack API does not tell us what is a floating ip vs a fixed ip for the vm listing,
          # we fall back to get all addresses and filter sadly.
          # Only includes manually-assigned addresses, not auto-assigned
          @all_addresses ||= service.list_all_addresses.body["floating_ips"].select{|data| data['instance_id'] == id}
        end

        def reload
          @all_addresses = nil
          super
        end

        # returns all ip_addresses for a given instance
        # this includes both the fixed ip(s) and the floating ip(s)
        def ip_addresses
          addresses.values.flatten.map{|x| x['addr']}
        end

        def floating_ip_addresses
          all_floating=addresses.values.flatten.select{ |data| data["OS-EXT-IPS:type"]=="floating" }.map{|addr| addr["addr"] }

          # Return them all, leading with manually assigned addresses
          manual = all_addresses.map{|addr| addr["ip"]}

          all_floating.sort{ |a,b|
            a_manual = manual.include? a
            b_manual = manual.include? b

            if a_manual and !b_manual
              -1
            elsif !a_manual and b_manual
              1
            else 0 end
          }
          all_floating.empty? ? manual : all_floating
        end

        alias_method :public_ip_addresses, :floating_ip_addresses

        def floating_ip_address
          floating_ip_addresses.first
        end

        alias_method :public_ip_address, :floating_ip_address

        def private_ip_addresses
          ip_addresses - floating_ip_addresses
        end

        def private_ip_address
          private_ip_addresses.first
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

        def failed?
          self.state == 'ERROR'
        end

        def change_password(admin_password)
          requires :id
          service.change_server_password(id, admin_password)
          true
        end

        def rebuild(image_ref, name, admin_pass=nil, metadata=nil, personality=nil)
          requires :id
          service.rebuild_server(id, image_ref, name, admin_pass, metadata, personality)
          true
        end

        def resize(flavor_ref)
          requires :id
          service.resize_server(id, flavor_ref)
          true
        end

        def revert_resize
          requires :id
          service.revert_resize_server(id)
          true
        end

        def confirm_resize
          requires :id
          service.confirm_resize_server(id)
          true
        end

        def security_groups
          requires :id

          groups = service.list_security_groups(id).body['security_groups']

          groups.map do |group|
            Fog::Compute::OpenStack::SecurityGroup.new group.merge({:service => service})
          end
        end

        def security_groups=(new_security_groups)
          @security_groups = new_security_groups
        end

        def reboot(type = 'SOFT')
          requires :id
          service.reboot_server(id, type)
          true
        end

        def stop
          requires :id
          service.stop_server(id)
        end

        def pause
          requires :id
          service.pause_server(id)
        end

        def suspend
          requires :id
          service.suspend_server(id)
        end

        def start
          requires :id

          case state.downcase
          when 'paused'
            service.unpause_server(id)
          when 'suspended'
            service.resume_server(id)
          else
            service.start_server(id)
          end
        end

        def create_image(name, metadata={})
          requires :id
          service.create_image(id, name, metadata)
        end

        def console(log_length = nil)
          requires :id
          service.get_console_output(id, log_length)
        end

        def migrate
          requires :id
          service.migrate_server(id)
        end

        def live_migrate(host, block_migration, disk_over_commit)
          requires :id
          service.live_migrate_server(id, host, block_migration, disk_over_commit)
        end

        def associate_address(floating_ip)
          requires :id
          service.associate_address id, floating_ip
        end

        def disassociate_address(floating_ip)
          requires :id
          service.disassociate_address id, floating_ip
        end

        def reset_vm_state(vm_state)
          requires :id
          service.reset_server_state id, vm_state
        end

        def min_count=(new_min_count)
          @min_count = new_min_count
        end

        def max_count=(new_max_count)
          @max_count = new_max_count
        end

        def networks
          service.networks(:server => self)
        end

        def volumes
          requires :id
          service.volumes.select do |vol|
            vol.attachments.find { |attachment| attachment["serverId"] == id }
          end
        end

        def volume_attachments
          requires :id
          service.get_server_volumes(id).body['volumeAttachments']
        end

        def attach_volume(volume_id, device_name)
          requires :id
          service.attach_volume(volume_id, id, device_name)
          true
        end

        def detach_volume(volume_id)
          requires :id
          service.detach_volume(id, volume_id)
          true
        end

        def save
          raise Fog::Errors::Error.new('Resaving an existing object may create a duplicate') if persisted?
          requires :flavor_ref, :name
          requires_one :image_ref, :block_device_mapping, :block_device_mapping_v2
          options = {
            'personality' => personality,
            'accessIPv4' => accessIPv4,
            'accessIPv6' => accessIPv6,
            'availability_zone' => availability_zone,
            'user_data' => user_data_encoded,
            'key_name'    => key_name,
            'config_drive' => config_drive,
            'security_groups' => @security_groups,
            'min_count'   => @min_count,
            'max_count'   => @max_count,
            'nics' => @nics,
            'os:scheduler_hints' => @os_scheduler_hints,
            'block_device_mapping' => @block_device_mapping,
            'block_device_mapping_v2' => @block_device_mapping_v2,
          }
          options['metadata'] = metadata.to_hash unless @metadata.nil?
          options = options.reject {|key, value| value.nil?}
          data = service.create_server(name, image_ref, flavor_ref, options)
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
