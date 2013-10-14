module Fog
  module Compute
    class VcloudDirector
      class Real
        # Delete a vApp or VM.
        #
        # This operation is asynchronous and returns a task that you can
        # monitor to track the progress of the request.
        #
        # @param [String] id Object identifier of the vApp.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @raise [Fog::Compute::VcloudDirector::BadRequest]
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/DELETE-VApp.html
        # @since vCloud API version 0.9
        def delete_vapp(id)
          request(
            :expects => 202,
            :method  => 'DELETE',
            :parser  => Fog::ToHashDocument.new,
            :path    => "vApp/#{id}"
          )
        end
      end
    end
  end
end
