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

        # Return an attribute hash suitable for the initializer given a
        # vSphere Managed Object (mob) instance.
        def self.attribute_hash_from_mob(vm)
          return {} unless vm
          # A cloning VM doesn't have a configuration yet.  Unfortuantely we just get
          # a RunTime exception.
          begin
            is_ready = vm.config ? true : false
          rescue RuntimeError
            is_ready = nil
          end
          {
            :id               => is_ready ? vm.config.instanceUuid : vm._ref,
            :name             => vm.name,
            :uuid             => is_ready ? vm.config.uuid : 'unavailable',
            :instance_uuid    => is_ready ? vm.config.instanceUuid : 'unavailable',
            :hostname         => vm.summary.guest.hostName,
            :operatingsystem  => vm.summary.guest.guestFullName,
            :ipaddress        => vm.summary.guest.ipAddress,
            :power_state      => vm.runtime.powerState,
            :connection_state => vm.runtime.connectionState,
            :hypervisor       => vm.runtime.host ? vm.runtime.host.name : 'unknown',
            :tools_state      => vm.summary.guest.toolsStatus,
            :tools_version    => vm.summary.guest.toolsVersionStatus,
            :mac_addresses    => is_ready ? vm.macs : nil,
            :is_a_template    => is_ready ? vm.config.template : nil
          }
        end

        def start
          requires :instance_uuid
          connection.vm_power_on(:instance_uuid => instance_uuid)
        end

        def stop(params = {})
          params = { :force => false }.merge(params)
          requires :instance_uuid
          connection.vm_power_off(:instance_uuid => instance_uuid, :force => params[:force])
        end

        def reboot(params = {})
          params = { :force => false }.merge(params)
          requires :instance_uuid
          connection.vm_reboot(:instance_uuid => instance_uuid, :force => params[:force])
        end

        def destroy(params = {})
          requires :instance_uuid
          connection.vm_destroy(:instance_uuid => instance_uuid)
        end

      end

    end
  end
end
