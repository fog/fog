module Fog
  module Compute
    class VcloudDirector
      class Real
        # Perform storage profile compliance check on a VM.
        #
        # This operation is asynchronous and return a task. When the task
        # completes, the compliance check on the VM has been completed and the
        # results can be retrieved.
        #
        # @param [String] id Object identifier of the VM.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/POST-CheckVmCompliance.html
        # @since vCloud API version 5.1
        def post_check_vm_compliance(id)
          request(
            :expects => 202,
            :method  => 'POST',
            :parser  => Fog::ToHashDocument.new,
            :path    => "vApp/#{id}/action/checkCompliance"
          )
        end
      end
    end
  end
end
