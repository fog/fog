module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieves the lease settings section of a vApp.
        #
        # @param [String] id Object identifier of the vApp.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-LeaseSettingsSection-vApp.html
        # @since vCloud API version 1.0
        def get_lease_settings_section_vapp(id)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "vApp/#{id}/leaseSettingsSection"
          )
        end
      end

      class Mock

        def get_lease_settings_section_vapp(id)

          type = 'application/vnd.vmware.vcloud.leaseSettingsSection+xml'

          unless vapp = data[:vapps][id]
            raise Fog::Compute::VcloudDirector::Forbidden.new(
              'This operation is denied.'
            )
          end

          Excon::Response.new(
            :status => 200,
            :headers => {'Content-Type' => "#{type};version=#{api_version}"},
            :body => get_vapp_lease_settings_section_body(id)
          )

        end

        def get_vapp_lease_settings_section_body(id)
          {
            :type => "application/vnd.vmware.vcloud.leaseSettingsSection+xml",
            :href => make_href("vApp/#{id}/leaseSettingsSection/"),
            :ovf_required=>"false",
            :"ovf:Info"=>"Lease settings section",
            :DeploymentLeaseInSeconds=>"0",
            :StorageLeaseInSeconds=>"0",
          }
        end

      end

    end
  end
end
