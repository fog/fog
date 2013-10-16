module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve metadata associated with the organization.
        #
        # @param [String] id Object identifier of the organization.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-OrganizationMetadata.html
        # @since vCloud API version 1.5
        def get_organization_metadata(id)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "org/#{id}/metadata"
          )
        end
      end
    end
  end
end
