module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve the startup section of a vApp.
        #
        # @param [String] id Object identifier of the vApp.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-StartupSection.html
        # @since vCloud API version 0.9
        def get_startup_section(id)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "vApp/#{id}/startupSection"
          )
        end
      end

      class Mock

        def get_startup_section(id)

          type = 'application/vnd.vmware.vcloud.startupSection+xml'

          unless vapp = data[:vapps][id]
            raise Fog::Compute::VcloudDirector::Forbidden.new(
              'This operation is denied.'
            )
          end

          Excon::Response.new(
            :status => 200,
            :headers => {'Content-Type' => "#{type};version=#{api_version}"},
            :body => get_vapp_ovf_startup_section_body(id, vapp)
          )

        end

        def get_vapp_ovf_startup_section_body(id, vapp)
          {
            :xmlns_ns12 => "http://www.vmware.com/vcloud/v1.5",
            :ns12_href => make_href("vApp/#{id}"),
            :ns12_type => "application/vnd.vmware.vcloud.startupSection+xml",
            :"ovf:Info" => "VApp startup section",
            :"ovf:Item" => {
              :ovf_stopDelay => "0",
              :ovf_stopAction => "powerOff",
              :ovf_startDelay => "0",
              :ovf_startAction => "powerOn",
              :ovf_order => "0",
              :ovf_id => vapp[:name],
            },
          }
        end

      end
    end
  end
end
