module Fog
  module Compute
    class VcloudDirector
      class Real
        # Deletes shadow VM.
        #
        # This operation is asynchronous and returns a task that you can
        # monitor to track the progress of the request.
        #
        # @deprecated Since vCloud API version 5.1 this operation may be
        #   removed in a future release.
        #
        # @param [String] id Object identifier of the vApp.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/DELETE-ShadowVm.html
        # @since vCloud API version 1.5
        def delete_shadow_vm(id)
          request(
            :expects => 202,
            :method  => 'DELETE',
            :parser  => Fog::ToHashDocument.new,
            :path    => "shadowVm/#{id}"
          )
        end
      end
    end
  end
end
