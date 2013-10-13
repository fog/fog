module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve a question being asked by a VM.
        #
        # @param [String] id Object identifier of the VM.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-VmPendingQuestion.html
        # @since vCloud API version 0.9
        def get_vm_pending_question(id)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "vApp/#{id}/question"
          )
        end
      end
    end
  end
end
