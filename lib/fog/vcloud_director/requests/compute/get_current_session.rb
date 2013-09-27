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
        # === Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #
        # {vCloud API Documentation}[http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-CurrentSession.html]
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
            {:xmlns => xmlns,
             :xmlns_xsi => xmlns_xsi,
             :user => user_name,
             :org => data[:org][:name],
             :type => 'application/vnd.vmware.vcloud.session+xml',
             :href => make_href('session/'),
             :xsi_schemaLocation=> xsi_schema_location,
             :Link =>
               [{:rel => 'down',
                 :type => 'application/vnd.vmware.vcloud.orgList+xml',
                 :href => make_href('org/')},
               {:rel => 'down',
                :type => 'application/vnd.vmware.admin.vcloud+xml',
                :href => make_href('admin/')},
               {:rel => 'down',
                :type => 'application/vnd.vmware.vcloud.org+xml',
                :name => data[:org][:name],
                :href => make_href("org/#{data[:org][:uuid]}")},
               {:rel => 'down',
                :type => 'application/vnd.vmware.vcloud.query.queryList+xml',
                :href => make_href('query')},
               {:rel => 'entityResolver',
                :type => 'application/vnd.vmware.vcloud.entity+xml',
                :href => make_href('entity/')}]}
          if @api_version.to_f >= 5.1
            body[:Link] << {
              :rel => 'down:extensibility',
              :type => 'application/vnd.vmware.vcloud.apiextensibility+xml',
              :href => make_href('extensibility')
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
