module Fog
  module Compute
    class VcloudDirector
      class Real
        # Log in and create a Session object.
        #
        # @return [Excon::Response]
        #   * body<~Hash>:
        #     * :href<~String> - The URI of the entity.
        #     * :type<~String> - The MIME type of the entity.
        #     * :org<~String> - The name of the user's organization.
        #     * :user<~String> - The name of the user that owns the session
        #     * :Link<~Array<Hash>]:
        #       * :href<~String> - Contains the URI to the linked entity.
        #       * :name<~String> - Contains the name of the linked entity.
        #       * :type<~String> - Contains the type of the linked entity.
        #       * :rel<~String> - Defines the relationship of the link to the
        #         object that contains it.
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/POST-Login-sessions.html
        # @since vCloud API version 1.5
        def post_login_session
          headers = {
            'Accept' => "application/*+xml;version=#{@api_version}",
            'Authorization' => "Basic #{Base64.encode64("#{@vcloud_director_username}:#{@vcloud_director_password}").delete("\r\n")}"
          }

          @connection.request(
            :expects => 200,
            :headers => headers,
            :method  => 'POST',
            :parser  => Fog::ToHashDocument.new,
            :path    => "#{@path}/sessions"
          )
        end
      end
    end
  end
end
