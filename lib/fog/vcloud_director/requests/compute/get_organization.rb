module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve an organization.
        #
        # @param [String] org_id ID of the organization.
        # @return [Excon:Response]
        #   * body<~Hash>:
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-Organization.html
        #   vCloud API Documentation
        # @since vCloud API version 0.9
        def get_organization(org_id)
          request({
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "org/#{org_id}"
          })
        end
      end

      class Mock
        def get_organization(org_id)
          response = Excon::Response.new

          org = data[:org]
          unless org_id == org[:uuid]
            response.status = 403
            raise(Excon::Errors.status_error({:expects => 200}, response))
          end

          body =
            {:xmlns=>xmlns,
             :xmlns_xsi=>xmlns_xsi,
             :name=>org[:name],
             :id=>"urn:vcloud:org:#{org[:uuid]}",
             :type=>"application/vnd.vmware.vcloud.org+xml",
             :href=>make_href("org/#{org[:uuid]}"),
             :xsi_schemaLocation=>xsi_schema_location,
             :Link=>
              [{:rel=>"down",
                :type=>"application/vnd.vmware.vcloud.vdc+xml",
                :name=>data[:vdc][:name],
                :href=>make_href("vdc/#{data[:vdc][:uuid]}")},
               {:rel=>"down",
                :type=>"application/vnd.vmware.vcloud.tasksList+xml",
                :href=>make_href("tasksList/#{org[:uuid]}")},
               {:rel=>"down",
                :type=>"application/vnd.vmware.vcloud.catalog+xml",
                :name=>data[:catalog][:name],
                :href=>make_href("catalog/#{data[:catalog][:uuid]}")},
               {:rel=>"down",
                :type=>"application/vnd.vmware.vcloud.controlAccess+xml",
                :href=>
                 make_href("org/#{org[:uuid]}/catalog/#{data[:catalog][:uuid]}/controlAccess/")},
               {:rel=>"controlAccess",
                :type=>"application/vnd.vmware.vcloud.controlAccess+xml",
                :href=>
                 make_href("org/#{org[:uuid]}/catalog/#{data[:catalog][:uuid]}/action/controlAccess")},
               {:rel=>"add",
                :type=>"application/vnd.vmware.admin.catalog+xml",
                :href=>make_href("admin/org/#{org[:uuid]}/catalogs")},
               {:rel=>"down",
                :type=>"application/vnd.vmware.vcloud.metadata+xml",
                :href=>make_href("org/#{org[:uuid]}/metadata")}],
             :Description=>org[:description]||'',
             :FullName=>org[:full_name]}

          body[:Link] += data[:networks].map do |network|
            {:rel=>"down",
             :type=>"application/vnd.vmware.vcloud.orgNetwork+xml",
             :name=>network[:name],
             :href=>make_href("network/#{network[:uuid]}")}
          end

          response.status = 200
          response.headers = {'Content-Type' => "#{body[:type]};version=#{api_version}"}
          response.body = body
          response
        end
      end
    end
  end
end
