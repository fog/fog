require 'fog/compute/models/server'

module Fog
  module Compute
    class Vsphere

      class Server < Fog::Compute::Server

        # This will be the instance uuid which is globally unique across
        # a vSphere deployment.
        identity  :id

        # JJM REVISIT (Extend the model of a vmware server)
        # SEE: http://www.vmware.com/support/developer/vc-sdk/visdk41pubs/ApiReference/vim.VirtualMachine.html
        # (Take note of the See also section.)
        # In particular:
        #   GuestInfo: information about the guest operating system
        #   VirtualMachineConfigInfo: Access to the VMX file and configuration

        attribute :name
        # UUID may be the same from VM to VM if the user does not select (I copied it)
        attribute :uuid
        attribute :hostname
        attribute :operatingsystem
        attribute :ipaddress,     :aliases => 'public_ip_address'
        attribute :power_state,   :aliases => 'power'
        attribute :tools_state,   :aliases => 'tools'
        attribute :tools_version
        attribute :mac_addresses, :aliases => 'macs'
        attribute :hypervisor,    :aliases => 'host'
        attribute :connection_state
        attribute :mo_ref
        attribute :path
        attribute :memory_mb
        attribute :cpus
        attribute :interfaces
        attribute :volumes
        attribute :overall_status, :aliases => 'status'
        attribute :cluster
        attribute :datacenter
        attribute :resource_pool
        attribute :instance_uuid # move this --> id
        attribute :guest_id

        def initialize(attributes={} )
          super defaults.merge(attributes)
          self.instance_uuid ||= id # TODO: remvoe instance_uuid as it can be replaced with simple id
          initialize_interfaces
          initialize_volumes
        end

        def vm_reconfig_memory(options = {})
          requires :instance_uuid, :memory
          connection.vm_reconfig_memory('instance_uuid' => instance_uuid, 'memory' => memory)
        end

        def vm_reconfig_cpus(options = {})
          requires :instance_uuid, :cpus
          connection.vm_reconfig_cpus('instance_uuid' => instance_uuid, 'cpus' => cpus)
        end

        def vm_reconfig_hardware(options = {})
          requires :instance_uuid, :hardware_spec
          connection.vm_reconfig_hardware('instance_uuid' => instance_uuid, 'hardware_spec' => hardware_spec)
        end

        def start(options = {})
          requires :instance_uuid
          connection.vm_power_on('instance_uuid' => instance_uuid)
        end

        def stop(options = {})
          options = { :force => !tools_installed? }.merge(options)
          requires :instance_uuid
          connection.vm_power_off('instance_uuid' => instance_uuid, 'force' => options[:force])
        end

        def reboot(options = {})
          options = { :force => false }.merge(options)
          requires :instance_uuid
          connection.vm_reboot('instance_uuid' => instance_uuid, 'force' => options[:force])
        end

        def destroy(options = {})
          requires :instance_uuid
          stop if ready? # need to turn it off before destroying
          connection.vm_destroy('instance_uuid' => instance_uuid)
        end

        def migrate(options = {})
          options = { :priority => 'defaultPriority' }.merge(options)
          requires :instance_uuid
          connection.vm_migrate('instance_uuid' => instance_uuid, 'priority' => options[:priority])
        end

        def clone(options = {})
          requires :name, :datacenter
          # Convert symbols to strings
          req_options = options.inject({}) { |hsh, (k,v)| hsh[k.to_s] = v; hsh }
          # Give our path to the request
          req_options['path'] ="#{path}/#{name}"
          # Perform the actual clone
          clone_results = connection.vm_clone(req_options)
          # Create the new VM model.
          new_vm = self.class.new(clone_results['vm_attributes'])
          # We need to assign the collection and the connection otherwise we
          # cannot reload the model.
          new_vm.collection = self.collection
          new_vm.connection = self.connection
          # Return the new VM model.
          new_vm
        end

        def ready?
          power_state == "poweredOn"
        end

        def tools_installed?
          tools_state != "toolsNotInstalled"
        end

        # defines VNC attributes on the hypervisor
        def config_vnc(options = {})
          requires :instance_uuid
          connection.vm_config_vnc(options.merge('instance_uuid' => instance_uuid))
        end

        # returns a hash of VNC attributes required for connection
        def vnc
          requires :instance_uuid
          connection.vm_get_vnc(instance_uuid)
        end

        def memory
          memory_mb * 1024 * 1024
        end

        def mac
          interfaces.first.mac unless interfaces.empty?
        end

        def interfaces
          attributes[:interfaces] ||= id.nil? ? [] : connection.interfaces( :vm => self )
        end

        def volumes
          attributes[:volumes] ||= id.nil? ? [] : connection.volumes( :vm => self )
        end

        def folder
          return nil unless datacenter and path
          attributes[:folder] ||= connection.folders(:datacenter => datacenter, :type => :vm).get(path)
        end

        def save
          requires :name, :cluster, :datacenter
          if identity
            raise "update is not supported yet"
           # connection.update_vm(attributes)
          else
            self.id = connection.create_vm(attributes)
          end
          reload
        end

        def new?
          id.nil?
        end

        def reload
          # reload does not re-read assoiciated attributes, so we clear it manually
          [:interfaces, :volumes].each do |attr|
            self.attributes.delete(attr)
          end
          super
        end

        private

        def defaults
          {
            :cpus      => 1,
            :memory_mb => 512,
            :guest_id  => 'otherGuest',
            :path      => '/'
          }
        end

        def initialize_interfaces
          if attributes[:interfaces] and attributes[:interfaces].is_a?(Array)
            self.attributes[:interfaces].map! { |nic| nic.is_a?(Hash) ? connection.interfaces.new(nic) : nic }
          end
        end

        def initialize_volumes
          if attributes[:volumes] and attributes[:volumes].is_a?(Array)
            self.attributes[:volumes].map! { |vol| vol.is_a?(Hash) ? connection.volumes.new(vol) : vol }
          end
        end
      end

    end
  end
end
