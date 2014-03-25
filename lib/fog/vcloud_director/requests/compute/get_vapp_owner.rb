module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve the owner of a vApp.
        #
        # @param [String] id Object identifier of the vApp.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-VAppOwner.html
        # @since vCloud API version 1.5
        def get_vapp_owner(id)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "vApp/#{id}/owner"
          )
        end
      end
    end
  end
end
