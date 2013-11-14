require 'fog/compute/models/server'

module Fog
  module Compute
    class Vsphere

      class Server < Fog::Compute::Server
        extend Fog::Deprecation
        deprecate(:ipaddress, :public_ip_address)

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
        attribute :public_ip_address, :aliases => 'ipaddress'
        attribute :power_state,   :aliases => 'power'
        attribute :tools_state,   :aliases => 'tools'
        attribute :tools_version
        attribute :mac_addresses, :aliases => 'macs'
        attribute :hypervisor,    :aliases => 'host'
        attribute :connection_state
        attribute :mo_ref
        attribute :path
        attribute :relative_path
        attribute :memory_mb
        attribute :cpus
        attribute :corespersocket
        attribute :interfaces
        attribute :volumes
        attribute :customvalues
        attribute :overall_status, :aliases => 'status'
        attribute :cluster
        attribute :datacenter
        attribute :resource_pool
        attribute :instance_uuid # move this --> id
        attribute :guest_id
        attribute :scsi_controller # this is the first scsi controller. Right now no more of them can be used.

        def initialize(attributes={} )
          super defaults.merge(attributes)
          self.instance_uuid ||= id # TODO: remvoe instance_uuid as it can be replaced with simple id
          initialize_interfaces
          initialize_volumes
          initialize_customvalues
          initialize_scsi_controller
        end

        # Lazy Loaded Attributes
        [:datacenter, :cluster, :hypervisor, :resource_pool, :mac_addresses].each do |attr|
          define_method attr do
            attributes[attr] = attributes[attr].call if attributes[attr].is_a?(Proc)
            attributes[attr]
          end
        end
        # End Lazy Loaded Attributes


        def vm_reconfig_memory(options = {})
          requires :instance_uuid, :memory
          service.vm_reconfig_memory('instance_uuid' => instance_uuid, 'memory' => memory_mb)
        end

        def vm_reconfig_cpus(options = {})
          requires :instance_uuid, :cpus, :corespersocket
          service.vm_reconfig_cpus('instance_uuid' => instance_uuid, 'cpus' => cpus, 'corespersocket' => corespersocket)
        end

        def vm_reconfig_hardware(hardware_spec, options = {})
          requires :instance_uuid
          service.vm_reconfig_hardware('instance_uuid' => instance_uuid, 'hardware_spec' => hardware_spec)
        end

        def start(options = {})
          requires :instance_uuid
          service.vm_power_on('instance_uuid' => instance_uuid)
        end

        def stop(options = {})
          options = { :force => !tools_installed? || !tools_running? }.merge(options)
          requires :instance_uuid
          service.vm_power_off('instance_uuid' => instance_uuid, 'force' => options[:force])
        end

        def reboot(options = {})
          options = { :force => false }.merge(options)
          requires :instance_uuid
          service.vm_reboot('instance_uuid' => instance_uuid, 'force' => options[:force])
        end

        def destroy(options = {})
          requires :instance_uuid
          if ready?
            # need to turn it off before destroying
            stop(options)
            wait_for { !ready? }
          end
          service.vm_destroy('instance_uuid' => instance_uuid)
        end

        def migrate(options = {})
          options = { :priority => 'defaultPriority' }.merge(options)
          requires :instance_uuid
          service.vm_migrate('instance_uuid' => instance_uuid, 'priority' => options[:priority])
        end

        # Clone from a server object
        #
        # ==== Parameters
        # *<~Hash>:
        #   * 'name'<~String> - *REQUIRED* Name of the _new_ VirtualMachine
        #   * See more options in vm_clone request/compute/vm_clone.rb
        #
        def clone(options = {})
          requires :name, :datacenter, :relative_path

          # Convert symbols to strings
          req_options = options.inject({}) { |hsh, (k,v)| hsh[k.to_s] = v; hsh }

          # Give our path to the request
          req_options['template_path'] ="#{relative_path}/#{name}"
          req_options['datacenter'] = "#{datacenter}"

          # Perform the actual clone
          clone_results = service.vm_clone(req_options)

          # We need to assign the service, otherwise we can't reload the model
          # Create the new VM model. TODO This only works when "wait=true"
          new_vm = self.class.new(clone_results['new_vm'].merge(:service => self.service))

          # We need to assign the collection otherwise we
          # cannot reload the model.
          new_vm.collection = self.collection

          # Return the new VM model.
          new_vm
        end

        def ready?
          power_state == "poweredOn"
        end

        def tools_installed?
          tools_state != "toolsNotInstalled"
        end

        def tools_running?
          tools_state == "toolsOk"
        end

        # defines VNC attributes on the hypervisor
        def config_vnc(options = {})
          requires :instance_uuid
          service.vm_config_vnc(options.merge('instance_uuid' => instance_uuid))
        end

        # returns a hash of VNC attributes required for service
        def vnc
          requires :instance_uuid
          service.vm_get_vnc(instance_uuid)
        end

        def memory
          memory_mb * 1024 * 1024
        end

        def sockets
          cpus / corespersocket
        end
        
        def mac
          interfaces.first.mac unless interfaces.empty?
        end

        def interfaces
          attributes[:interfaces] ||= id.nil? ? [] : service.interfaces( :server => self )
        end
        
        def interface_ready? attrs
          (attrs.is_a? Hash and attrs[:blocking]) or attrs.is_a? Fog::Compute::Vsphere::Interface
        end

        def add_interface attrs
          Fog::Logger.deprecation("<server>.add_interface is deprecated. Call <server>.interfaces.create instead.")

          interfaces.create(attrs)
        end

        def update_interface attrs
          wait_for { not ready? } if interface_ready? attrs
          service.update_vm_interface(id, attrs)
        end

        def destroy_interface attrs
          Fog::Logger.deprecation("<server>.destroy_vm_interface is deprecated. Call <server>.interfaces.get(:key => <nic_key>).destroy instead.")

          interfaces.get(attrs[:key] || attrs['key']).destroy
        end

        def volumes
          attributes[:volumes] ||= id.nil? ? [] : service.volumes(:server => self)
        end

        def customvalues
          attributes[:customvalues] ||= id.nil? ? [] : service.customvalues( :vm => self )
        end

        def scsi_controller
          self.attributes[:scsi_controller] ||= service.get_vm_first_scsi_controller(id)
        end

        def folder
          return nil unless datacenter and path
          attributes[:folder] ||= service.folders(:datacenter => datacenter, :type => :vm).get(path)
        end

        def save
          requires :name, :cluster, :datacenter
          if persisted?
            raise "update is not supported yet"
           # service.update_vm(attributes)
          else
            self.id = service.create_vm(attributes)
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
#            :corespersocket => 1,
            :memory_mb => 512,
            :guest_id  => 'otherGuest',
            :path      => '/'
          }
        end

        def initialize_interfaces
          if attributes[:interfaces] and attributes[:interfaces].is_a?(Array)
            self.attributes[:interfaces].map! { |nic| nic.is_a?(Hash) ? service.interfaces.new(nic) : nic }
          end
        end

        def initialize_volumes
          if attributes[:volumes] and attributes[:volumes].is_a?(Array)
            self.attributes[:volumes].map! { |vol| vol.is_a?(Hash) ? service.volumes.new(vol) : vol }
          end
        end
        
        def initialize_customvalues
          if attributes[:customvalues] and attributes[:customvalues].is_a?(Array)
            self.attributes[:customvalues].map { |cfield| cfield.is_a?(Hash) ? service.customvalue.new(cfield) : cfield}
          end
        end

        def initialize_scsi_controller
          if attributes[:scsi_controller] and attributes[:scsi_controller].is_a?(Hash)
            Fog::Compute::Vsphere::SCSIController.new(self.attributes[:scsi_controller])
          end
        end

      end

    end
  end
end
