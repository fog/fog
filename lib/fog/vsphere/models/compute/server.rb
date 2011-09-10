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
        # Instance UUID should be unique across a vCenter deployment.
        attribute :instance_uuid
        attribute :hostname
        attribute :operatingsystem
        attribute :ipaddress
        attribute :power_state,   :aliases => 'power'
        attribute :tools_state,   :aliases => 'tools'
        attribute :tools_version
        attribute :mac_addresses, :aliases => 'macs'
        attribute :hypervisor,    :aliases => 'host'
        attribute :is_a_template
        attribute :connection_state
        attribute :mo_ref

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

      end

    end
  end
end
