module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieves the lease settings section of a vApp template.
        #
        # @param [String] id Object identifier of the vApp template.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-LeaseSettingsSection-vAppTemplate.html
        # @since vCloud API version 0.9
        def get_lease_settings_section_vapp_template(id)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "vAppTemplate/#{id}/leaseSettingsSection"
          )
        end
      end
    end
  end
end
