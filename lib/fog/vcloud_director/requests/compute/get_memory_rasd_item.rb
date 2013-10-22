module Fog
  module Compute
    class VcloudDirector
      class Real
        extend Fog::Deprecation
        deprecate :get_vm_memory, :get_memory_rasd_item

        # Retrieve the RASD item that specifies memory properties of a VM.
        #
        # @param [String] id Object identifier of the VM.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-MemoryRasdItem.html
        # @since vCloud API version 0.9
        def get_memory_rasd_item(id)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "vApp/#{id}/virtualHardwareSection/memory"
          )
        end
      end
    end
  end
end
