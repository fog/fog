class Cloudstack
  module Compute
    module Constants
      # The template ID to be copied from one zone to another
      TEMPLATE_ID = 2
      # The source zone of the TEMPLATE_ID for copying
      FROM_ZONE_ID = 1
      # The destination zone of the TEMPLATE_ID for copying
      TO_ZONE_ID = 1
      # The OS ID to use for template creation
      OS_TYPE_ID = 12
      # The service offering which will be used to deploy a new vm (don't worry it gets deleted)
      SERVICE_OFFERING_ID = 15
      # The OS type of the system VM which will be registered
      SYSTEM_VM_OS_TYPE_ID = 15
      # The ID of a template which will be made public for update_template_permissions
      # and bootable for update_template
      TEMPLATE_ID_TO_MAKE_PUBLIC_AND_BOOTABLE = 2
    end

    module TestHelpers
      def deploy_vm_and_create_template(service_offering_id, template_id, zone_id, os_type_id)
        # Launch a VM to create a template from first
        vm = Fog::Compute[:cloudstack].deploy_virtual_machine(
          'serviceofferingid' => service_offering_id,
          'templateid' => template_id,
          'zoneid' => zone_id
        )

        timeout   = 60 * 10
        backoff   = [2,5,10]

        vmid = vm['deployvirtualmachineresponse']['id']

        timeout_message = "Timed out waiting for a virtual machine to be deployed.  Elapsed time was #{timeout} seconds"
        Cloudstack::Compute::TestHelpers.block_until_timeout(timeout_message, timeout, backoff) {
          vm = Fog::Compute[:cloudstack].list_virtual_machines('id' => vmid)
          vm['listvirtualmachinesresponse']['virtualmachine'].first['state'] != "Running"
        }

        Fog::Compute[:cloudstack].stop_virtual_machine('id' => vmid)

        Cloudstack::Compute::TestHelpers.block_until_timeout(timeout_message, timeout, backoff) {
          vm = Fog::Compute[:cloudstack].list_virtual_machines('id' => vmid)
          vm['listvirtualmachinesresponse']['virtualmachine'].first['state'] != "Stopped"
        }

        vmid = vm['listvirtualmachinesresponse']['virtualmachine'].first['id']
        root_device_id = Fog::Compute[:cloudstack].list_volumes('virtualmachineid' => vmid)['listvolumesresponse']['volume'].first['id']

        template_name = "FogTest-#{Time.now.to_i}"
        templ = Fog::Compute[:cloudstack].create_template(
          template_name,
          template_name,
          Cloudstack::Compute::Constants::OS_TYPE_ID,
          {'volumeid' => root_device_id})

        return vm, templ
      end

      module_function :deploy_vm_and_create_template

      def block_until_timeout(timeout_message, timeout, backoff, &block)
        begin
          idx = 0
          Timeout::timeout(timeout) do
            while true
              if yield
                Kernel.sleep(backoff[idx] || backoff.last)
                idx += 1
              else
                break
              end
            end
          end
        rescue
          raise timeout_message
        end
      end

      module_function :block_until_timeout
    end
  end
end