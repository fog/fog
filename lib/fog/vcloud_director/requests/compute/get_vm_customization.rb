module Fog
  module Compute
    class VcloudDirector
      class Real
        require 'fog/vcloud_director/parsers/compute/vm_customization'

        # Retrieves the guest customization section of a VM.
        #
        # @deprecated Use {#get_guest_customization_system_section_vapp}
        #   instead.
        # @todo Log deprecation warning.
        #
        # @param [String] id Object identifier of the VM.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-GuestCustomizationSystemSection-vApp.html
        # @since vCloud API version 1.0
        def get_vm_customization(id)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::Parsers::Compute::VcloudDirector::VmCustomization.new,
            :path       => "vApp/#{id}/guestCustomizationSection"
          )
        end
      end
    end
  end
end
