module Fog
  module Compute
    class VcloudDirector
      class Real
        def get_organization(organization_id)
          request({
            :expects => 200,
            :method  => 'GET',
            :parser  => Fog::ToHashDocument.new,
            :path    => "org/#{organization_id}"
          })
        end
      end

      class Mock
        def get_organization(organization_id)
          org = data[:org]

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
