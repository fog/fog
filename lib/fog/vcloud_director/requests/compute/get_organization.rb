module Fog
  module Compute
    class VcloudDirector
      class Real
        # Retrieve an organization.
        #
        # @param [String] id The object identifier of the organization.
        # @return [Excon:Response]
        #   * body<~Hash>:
        #
        # @raise [Fog::Compute::VcloudDirector::Forbidden]
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/GET-Organization.html
        # @since vCloud API version 0.9
        def get_organization(id)
          response = request(
            :expects    => 200,
            :idempotent => true,
            :method     => 'GET',
            :parser     => Fog::ToHashDocument.new,
            :path       => "org/#{id}"
          )
          ensure_list! response.body, :Tasks, :Task
          response
        end
      end

      class Mock
        def get_organization(id)
          unless id == data[:org][:uuid]
            raise Fog::Compute::VcloudDirector::Forbidden.new(
              "No access to entity \"com.vmware.vcloud.entity.org:#{id}\""
            )
          end
          org = data[:org]

          body =
            {:href=>make_href("org/#{id}"),
             :type=>"application/vnd.vmware.vcloud.org+xml",
             :id=>"urn:vcloud:org:#{id}",
             :name=>org[:name],
             :Link=>
              [{:href=>make_href("tasksList/#{id}"),
                :type=>"application/vnd.vmware.vcloud.tasksList+xml",
                :rel=>"down"},
               {:href=>make_href("admin/org/#{id}/catalogs"),
                :type=>"application/vnd.vmware.admin.catalog+xml",
                :rel=>"add"},
               {:href=>make_href("org/#{id}/metadata"),
                :type=>"application/vnd.vmware.vcloud.metadata+xml",
                :rel=>"down"}],
             :Description=>org[:description]||'',
             :Tasks=>{:Task=>[]},
             :FullName=>org[:full_name]}

          body[:Link] += data[:catalogs].map do |catalog_id, catalog|
            [{:href=>make_href("catalog/#{catalog_id}"),
              :name=>catalog[:name],
              :type=>"application/vnd.vmware.vcloud.catalog+xml",
              :rel=>"down"},
             {:href=>make_href("org/#{id}/catalog/#{catalog_id}/controlAccess/"),
              :type=>"application/vnd.vmware.vcloud.controlAccess+xml",
              :rel=>"down"},
             {:href=>
               make_href("org/#{id}/catalog/#{catalog_id}/action/controlAccess"),
              :type=>"application/vnd.vmware.vcloud.controlAccess+xml",
              :rel=>"controlAccess"}]
          end.flatten

          body[:Link] += data[:networks].map do |network_id, network|
            {:href=>make_href("network/#{network_id}"),
             :name=>network[:name],
             :type=>"application/vnd.vmware.vcloud.orgNetwork+xml",
             :rel=>"down"}
          end

          body[:Link] += data[:vdcs].map do |vdc_id, vdc|
            {:href=>make_href("vdc/#{vdc_id}"),
             :name=>vdc[:name],
             :type=>"application/vnd.vmware.vcloud.vdc+xml",
             :rel=>"down"}
          end

          if api_version.to_f >= 5.1
            body[:Link] <<
              {:href=>make_href('supportedSystemsInfo/'),
               :type=>"application/vnd.vmware.vcloud.supportedSystemsInfo+xml",
               :rel=>"down"}
          end

          Excon::Response.new(
            :body    => body,
            :headers => {'Content-Type' => "#{body[:type]};version=#{api_version}"},
            :status  => 200
          )
        end
      end
    end
  end
end
