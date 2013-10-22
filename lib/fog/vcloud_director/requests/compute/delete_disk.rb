module Fog
  module Compute
    class VcloudDirector
      class Real
        # Delete a disk.
        #
        # This operation is asynchronous and returns a task that you can
        # monitor to track the progress of the request.
        #
        # @param [String] id Object identifier of the disk.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/DELETE-Disk.html
        # @since vCloud API version 5.1
        def delete_disk(id)
          request(
            :expects => 202,
            :method  => 'DELETE',
            :parser  => Fog::ToHashDocument.new,
            :path    => "disk/#{id}"
          )
        end
      end
    end
  end
end
