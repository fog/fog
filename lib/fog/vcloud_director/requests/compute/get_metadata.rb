module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve metadata associated with the vApp or VM.
        #
        # @param [String] vm_id The ID of the vApp or VM.
        # @return [Excon::Response]
        #   * body<~Hash>:
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-VAppMetadata.html
        #   vCloud API Documentation
        # @since vCloud API version 1.5
        def get_metadata(vm_id)
          require 'fog/vcloud_director/parsers/compute/metadata'

          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::Parsers::Compute::VcloudDirector::Metadata.new,
            :path       => "vApp/#{vm_id}/metadata/"
          )
        end
      end
    end
  end
end
