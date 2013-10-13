module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve the virtual hardware section of a VM.
        #
        # This operation retrieves the entire VirtualHardwareSection of a VM.
        # You can also retrieve many RASD item elements of a
        # VirtualHardwareSection individually, or as groups of related items.
        #
        # @param [String] id Object identifier of the VM.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-VirtualHardwareSection.html
        # @since vCloud API version 0.9
        def get_virtual_hardware_section(id)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "vApp/#{id}/virtualHardwareSection/"
          )
        end
      end
    end
  end
end
