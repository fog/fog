module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve the owner of a disk.
        #
        # @param [String] id Object identifier of the disk.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #     * :href<~String> - The URI of the disk.
        #     * :type<~String> - The MIME type of the disk.
        #     * :Link<~Hash>:
        #       * :href<~String> -
        #       * :type<~String> -
        #       * :rel<~String> -
        #     * :User<~Hash> - Reference to the user who is the owner of this
        #       disk.
        #       * :href<~String> - The URI of the user.
        #       * :name<~String> - The name of the user.
        #       * :type<~String> - The MIME type of the user.
        #
        # @raise [Fog::Compute::VcloudDirector::Forbidden]
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-DiskOwner.html
        # @since vCloud API version 5.1
        def get_disk_owner(id)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "disk/#{id}/owner"
          )
        end
      end

      class Mock
        def get_disk_owner(id)
          unless data[:disks][id]
            raise Fog::Compute::VcloudDirector::Forbidden.new(
              'No access to entity "com.vmware.vcloud.entity.disk:%s".' % id
            )
          end

          body = {
            :xmlns => xmlns,
            :xmlns_xsi => xmlns_xsi,
            :xsi_schemaLocation => xsi_schema_location,
            :Link => {
              :href => make_href("disk/#{id}"),
              :type => 'application/vnd.vmware.vcloud.disk+xml',
              :rel => 'up'
            },
            :User => {
              :href => make_href("admin/user/#{user_uuid}"),
              :name => user_name,
              :type => 'application/vnd.vmware.admin.user+xml',
            }
          }

          Excon::Response.new(
            :status => 200,
            :headers => {'Content-Type' => "#{body[:type]};version=#{@version}"},
            :body => body
          )
        end
      end
    end
  end
end
