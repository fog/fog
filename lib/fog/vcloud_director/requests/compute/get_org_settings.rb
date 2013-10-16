module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve settings for this organization.
        #
        # Organization settings are divided into categories. This request
        # retrieves all categories of organization settings.
        #
        # @param [String] id Object identitifier of the organization.
        # @return [Excon:Response]
        #   * body<~Hash>:
        #     * :href<~String> - The URI of the entity.
        #     * :type<~String> - The MIME type of the entity.
        #     * :OrgGeneralSettings<~Hash>:
        #     * :VAppLeaseSettings<~Hash>:
        #     * :VAppTemplateLeaseSettings<~Hash>:
        #     * :OrgLdapSettings<~Hash>:
        #     * :OrgEmailSettings<~Hash>:
        #     * :OrgPasswordPolicySettings<~Hash>:
        #     * :OrgOperationLimitsSettings<~Hash>:
        #     * :OrgFederationSettings<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-OrgSettings.html
        # @since vCloud API version 0.9
        def get_org_settings(id)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "admin/org/#{id}/settings"
          )
        end
      end
    end
  end
end
