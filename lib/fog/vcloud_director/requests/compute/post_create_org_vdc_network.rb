module Fog
  module Compute
    class VcloudDirector
      class Real
        require 'fog/vcloud_director/generators/compute/org_vdc_network'
        def post_create_org_vdc_network(vdcid, options={})
          
          data = Fog::Generators::Compute::VcloudDirector::OrgVdcNetwork.new(options)
         

          request(
            :body    => data.generate_xml(),
            :expects => 201,
            :headers => {'Content-Type' => 'application/vnd.vmware.vcloud.orgVdcNetwork+xml'},
            :method  => 'POST',
            :parser  => Fog::ToHashDocument.new,
            :path    => "/admin/vdc/#{vdcid}/networks"
          )
        end
      end
      
      class Mock
        require 'fog/vcloud_director/generators/compute/org_vdc_network'
        def post_create_org_vdc_network(vdcid, options={})
          
          data = Fog::Generators::Compute::VcloudDirector::OrgVdcNetwork.new(options)
          body = data.generate_xml()
          
          response = Excon::Response.new(
                      :status => 200,
                      :headers => {'Type' => "application/OrgVdcNetwork+xml;version=#{api_version}"},
                      :body => body
                    )
          
          response
          
        end
      end
    end
  end
end
