module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve the results of a compliance check.
        #
        # @param [String] id Object identifier of the VM.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-VmComplianceResults.html
        def get_vm_compliance_results(id)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "vApp/#{id}/complianceResult"
          )
        end
      end
    end
  end
end
