module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve SnapshotSection element for a vApp or VM.
        #
        # @param [String] id Object identifier of the vApp or VM.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-SnapshotSection.html
        # @since vCloud API version 5.1
        def get_snapshot_section(id)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "vApp/#{id}/snapshotSection"
          )
        end
      end
    end
  end
end
