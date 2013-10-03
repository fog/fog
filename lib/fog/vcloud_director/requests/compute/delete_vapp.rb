module Fog
  module Compute
    class VcloudDirector
      class Real
        # Delete a vApp or VM.
        #
        # This operation is asynchronous and returns a task that you can
        # monitor to track the progress of the request.
        #
        # @param [String] vapp_id Object identifier of the vApp.
        # @return [Excon::Response]
        #   * body<~Hash>:
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/DELETE-VApp.html
        #   vCloud API Documentation
        # @since vCloud API version 0.9
        def delete_vapp(vapp_id)
          request(
            :expects => 202,
            :method  => 'DELETE',
            :parser  => Fog::ToHashDocument.new,
            :path    => "vApp/#{vapp_id}"
          )
        end
      end
    end
  end
end
