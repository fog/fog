module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieves the guest customization section of a VM.
        #
        # @param [String] id Object identifier of the VM.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-GuestCustomizationSystemSection-vAppTemplate.html
        # @since vCloud API version 1.0
        def get_guest_customization_system_section_vapp_template(id)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "vAppTemplate/#{id}/guestCustomizationSection"
          )
        end
      end
    end
  end
end
