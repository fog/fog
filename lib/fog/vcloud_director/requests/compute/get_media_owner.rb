module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve the owner of a media object.
        #
        # @param [String] id Object identifier of the media object.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #     * :href<~String> - The URI of the media object.
        #     * :type<~String> - The MIME type of the media object.
        #     * :Link<~Hash>:
        #       * :href<~String> -
        #       * :type<~String> -
        #       * :rel<~String> -
        #     * :User<~Hash> - Reference to the user who is the owner of this
        #       media object.
        #       * :href<~String> - The URI of the user.
        #       * :name<~String> - The name of the user.
        #       * :type<~String> - The MIME type of the user.
        #
        # @raise [Fog::Compute::VcloudDirector::Forbidden]
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-MediaOwner.html
        # @since vCloud API version 1.5
        def get_media_owner(id)
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "media/#{id}/owner"
          )
        end
      end

      class Mock
        def get_media_owner(id)
          unless data[:medias][id]
            raise Fog::Compute::VcloudDirector::Forbidden.new(
              'No access to entity "com.vmware.vcloud.entity.media:%s".' % id
            )
          end

          body = {
            :xmlns => xmlns,
            :xmlns_xsi => xmlns_xsi,
            :xsi_schemaLocation => xsi_schema_location,
            :Link => {
              :href => make_href("media/#{id}"),
              :type => 'application/vnd.vmware.vcloud.media+xml',
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
