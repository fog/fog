module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve all RASD items that specify hard disk and hard disk
        # controller properties of a VM.
        #
        # @param [String] id Object identifier of the VM.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-DisksRasdItemsList.html
        # @since vCloud API version 0.9
        def get_disks_rasd_items_list(id)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "vApp/#{id}/virtualHardwareSection/disks"
          )
        end
      end
    end
  end
end
