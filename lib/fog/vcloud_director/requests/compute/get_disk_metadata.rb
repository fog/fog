module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve metadata associated with the disk.
        #
        # @param [String] id Object identifier of the disk.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-DiskMetadata.html
        # @since vCloud API version 5.1
        def get_disk_metadata(id)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "disk/#{id}/metadata"
          )
        end
      end
    end
  end
end
