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
        attribute :uuid  # Instance UUID should be unique across a vCenter deployment.
        attribute :name
        attribute :hostname
        attribute :operatingsystem
        attribute :ipaddress
        attribute :power_state,   :aliases => 'state'
        attribute :tools_state,   :aliases => 'tools'
        attribute :tools_version
        attribute :mac_addresses, :aliases => 'macs'
        attribute :hypervisor,    :aliases => 'host'
        attribute :is_a_template
        attribute :connection_state
        attribute :mo_ref
        attribute :path
        attribute :template_path
        
        # attribute alias
        def state; power_state end
        def dns_name; hostname end
        def public_ip_address; ipaddress end
        def private_ip_address; ipaddress end
        def instance_uuid; id end

        def start(options = {})
          requires :instance_uuid
          connection.vm_power_on('instance_uuid' => instance_uuid)
        end

        def stop(options = {})
          options = { :force => false }.merge(options)
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
          connection.vm_destroy('instance_uuid' => instance_uuid)
        end

        #
        # :template_path the absolute or relative path of the VM template to be cloned
        # :name the name of VM to be created
        # 
        def clone(options = {})
          requires :template_path, :name
          # expand template_name to full path of the template file
          unless options[:template_path].start_with?('/')
            options[:template_path] = connection.vsphere_templates_folder + options[:template_path]
          end
          
          # Convert symbols to strings
          req_options = options.inject({}) { |hsh, (k,v)| hsh[k.to_s] = v; hsh }
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
        
        # ready to be connected
        def ready?
          !! ipaddress
        end

        def save()
          if id
            raise 'Saving an existing VM in vSphere has not been implemented yet!' # TODO: save updated attributes
          else
            new_vm = clone(self.attributes)
            merge_attributes(new_vm.attributes)
            return self
          end
        end
      end

    end
  end
end
