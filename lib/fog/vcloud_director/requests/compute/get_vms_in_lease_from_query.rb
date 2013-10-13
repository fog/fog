module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieves a list of VMs in lease by using REST API general
        # QueryHandler; If filter is provided it will be applied to the
        # corresponding result set. Format determines the elements
        # representation - references or records. Default format is references.
        #
        # @return [Excon::Response]
        #   * hash<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-VMsInLeaseFromQuery.html
        # @since vCloud API version 1.5
        def get_vms_in_lease_from_query
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => 'vms/query'
          )
        end
      end
    end
  end
end
