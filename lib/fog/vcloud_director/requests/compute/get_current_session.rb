module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve a representation of the current session.
        #
        # A Session object contains one or more URLs from which you can begin
        # browsing, as well as links to the query service and entity resolver.
        # The list of URLs in the Session object is based on the role and
        # privileges of the authenticated user.
        #
        # A Session object expires after a configurable interval of client
        # inactivity.
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
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-CurrentSession.html
        # @since vCloud API version 1.5
        def get_current_session
          request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => 'session'
          )
        end
      end

      class Mock
        def get_current_session
          body =
            {:href => make_href('session/'),
             :type => 'application/vnd.vmware.vcloud.session+xml',
             :org => data[:org][:name],
             :user => user_name,
             :Link =>
              [{:href => make_href('org/'),
                :type => 'application/vnd.vmware.vcloud.orgList+xml',
                :rel => 'down'},
               {:href => make_href('admin/'),
                :type => 'application/vnd.vmware.admin.vcloud+xml',
                :rel => 'down'},
               {:href => make_href("org/#{data[:org][:uuid]}"),
                :name => data[:org][:name],
                :type => 'application/vnd.vmware.vcloud.org+xml',
                :rel => 'down'},
               {:href => make_href('query'),
                :type => 'application/vnd.vmware.vcloud.query.queryList+xml',
                :rel => 'down'},
               {:href => make_href('entity/'),
                :type => 'application/vnd.vmware.vcloud.entity+xml',
                :rel => 'entityResolver'}]}

          if @api_version.to_f >= 5.1
            body[:Link] << {
              :href => make_href('extensibility'),
              :type => 'application/vnd.vmware.vcloud.apiextensibility+xml',
              :rel => 'down:extensibility'
            }
          end

          Excon::Response.new(
            :body => body,
            :headers => {'Content-Type' => "#{body[:type]};version=#{api_version}"},
            :status => 200
          )
        end
      end
    end
  end
end
