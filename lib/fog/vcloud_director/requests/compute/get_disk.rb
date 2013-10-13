module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve a disk.
        #
        # @param [String] id Object identifier of the disk.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-Disk.html
        # @since vCloud API version 5.1
        def get_disk(id)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "disk/#{id}"
          )
        end
      end
    end
  end
end
