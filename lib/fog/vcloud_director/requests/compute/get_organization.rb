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

          unless valid_uuid?(org_id)
            response.status = 400
            raise Excon::Errors.status_error({:expects => 200}, response)
          end
          unless org_id == data[:org][:uuid]
            response.status = 403
            raise(Excon::Errors.status_error({:expects => 200}, response))
          end
          org = data[:org]

          body =
            {:xmlns=>xmlns,
             :xmlns_xsi=>xmlns_xsi,
             :name=>org[:name],
             :id=>"urn:vcloud:org:#{org_id}",
             :type=>"application/vnd.vmware.vcloud.org+xml",
             :href=>make_href("org/#{org_id}"),
             :xsi_schemaLocation=>xsi_schema_location,
             :Link=>
              [{:rel=>"down",
                :type=>"application/vnd.vmware.vcloud.tasksList+xml",
                :href=>make_href("tasksList/#{org_id}")},
               {:rel=>"add",
                :type=>"application/vnd.vmware.admin.catalog+xml",
                :href=>make_href("admin/org/#{org_id}/catalogs")},
               {:rel=>"down",
                :type=>"application/vnd.vmware.vcloud.metadata+xml",
                :href=>make_href("org/#{org_id}/metadata")}],
             :Description=>org[:description]||'',
             :FullName=>org[:full_name]}

          body[:Link] += data[:catalogs].map do |id, catalog|
            [{:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.catalog+xml",
              :name=>catalog[:name],
              :href=>make_href("catalog/#{id}")},
             {:rel=>"down",
              :type=>"application/vnd.vmware.vcloud.controlAccess+xml",
              :href=>make_href("org/#{org_id}/catalog/#{id}/controlAccess/")},
             {:rel=>"controlAccess",
              :type=>"application/vnd.vmware.vcloud.controlAccess+xml",
              :href=>
               make_href("org/#{org_id}/catalog/#{id}/action/controlAccess")}]
          end.flatten

          body[:Link] += data[:networks].map do |id, network|
            {:rel=>"down",
             :type=>"application/vnd.vmware.vcloud.orgNetwork+xml",
             :name=>network[:name],
             :href=>make_href("network/#{id}")}
          end

          body[:Link] += data[:vdcs].map do |id, vdc|
            {:rel=>"down",
             :type=>"application/vnd.vmware.vcloud.vdc+xml",
             :name=>vdc[:name],
             :href=>make_href("vdc/#{id}")}
          end

          if api_version.to_f >= 5.1
            body[:Link] <<
              {:rel=>"down",
               :type=>"application/vnd.vmware.vcloud.supportedSystemsInfo+xml",
               :href=>make_href('supportedSystemsInfo/')}
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
