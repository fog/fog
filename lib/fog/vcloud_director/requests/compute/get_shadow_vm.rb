module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve a shadow VM.
        #
        # @param [String] id The object identifier of the shadow VM.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-ShadowVm.html
        def get_shadow_vm(id)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "shadowVm/#{id}"
          )
        end
      end
    end
  end
end
