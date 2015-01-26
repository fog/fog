module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve the owner of a vApp.
        #
        # @param [String] id Object identifier of the vApp.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-VAppOwner.html
        # @since vCloud API version 1.5
        def get_vapp_owner(id)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "vApp/#{id}/owner"
          )
        end
      end

      class Mock
        def get_vapp_owner(id)

          type = 'application/vnd.vmware.vcloud.owner+xml'

          unless vapp = data[:vapps][id]
            raise Fog::Compute::VcloudDirector::Forbidden.new(
              'This operation is denied.'
            )
          end

          Excon::Response.new(
            :status => 200,
            :headers => {'Content-Type' => "#{type};version=#{api_version}"},
            :body => get_owner_section_body(id)
          )

        end

        def get_owner_section_body(id)
          {
            :type => 'application/vnd.vmware.vcloud.owner+xml',
            :User => {
              :type => "application/vnd.vmware.admin.user+xml",
              :name => "mockuser",
              :href => make_href("user/12345678-1234-1234-1234-12345678df2b"),
            }
          }
        end

      end

    end
  end
end
