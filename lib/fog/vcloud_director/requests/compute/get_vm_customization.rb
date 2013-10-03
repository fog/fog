module Fog
  module Compute
    class VcloudDirector
      class Real
        require 'fog/vcloud_director/parsers/compute/vm_customization'

        # Retrieves the guest customization section of a VM.
        #
        # @deprecated Use {#get_guest_customization_system_section_vapp}
        #   instead.
        # @param [String] vm_id Object identifier of the VM.
        # @return [Excon::Response]
        #   * body<~Hash>:
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-GuestCustomizationSystemSection-vApp.html
        #   vCloud API Documentation
        # @since vCloud API version 1.0
        # @todo Log deprecation warning.
        def get_vm_customization(vm_id)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::Parsers::Compute::VcloudDirector::VmCustomization.new,
            :path       => "vApp/#{vm_id}/guestCustomizationSection"
          )
        end
      end
    end
  end
end
