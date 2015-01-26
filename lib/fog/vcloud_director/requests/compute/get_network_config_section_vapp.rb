module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve the network config section of a vApp.
        #
        # @param [String] id The object identifier of the vApp.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-NetworkConfigSection-vApp.html
        # @since vCloud API version 0.9
        def get_network_config_section_vapp(id)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "vApp/#{id}/networkConfigSection/"
          )
        end
      end

      class Mock

        def get_network_config_section_vapp(id)

          type = 'application/vnd.vmware.vcloud.networkConfigSection+xml'

          unless vapp = data[:vapps][id]
            raise Fog::Compute::VcloudDirector::Forbidden.new(
              'This operation is denied.'
            )
          end

          Excon::Response.new(
            :status => 200,
            :headers => {'Content-Type' => "#{type};version=#{api_version}"},
            :body => get_vapp_network_config_section_body(id, vapp)
          )

        end

        def get_vapp_network_config_section_body(id, vapp)
          # TODO: This is effectively hardcoding a vAppNetwork configuration
          #       into here, but this is sufficient for initial testing.
          #       This network configuration has no networks.

          {
            :type => "application/vnd.vmware.vcloud.networkConfigSection+xml",
            :href => make_href("vApp/#{id}/networkConfigSection/"),
            :ovf_required => "false",
            :"ovf:Info" => "The configuration parameters for logical networks",
            :NetworkConfig => [],
          }
        end

      end
    end
  end
end
