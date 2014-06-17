module Fog
  module Compute
    class VcloudDirector
      class Real
        require 'fog/vcloud_director/generators/compute/recompose_vapp'
        def post_recompose_vapp(id, options={})
          body = Fog::Generators::Compute::VcloudDirector::RecomposeVapp.new(options).generate_xml

          request(
            :body => body,
            :expects => 202,
            :headers => { 'Content-Type' => 'application/vnd.vmware.vcloud.recomposeVAppParams+xml' },
            :method => 'POST',
            :parser => Fog::ToHashDocument.new,
            :path => "vApp/#{id}/action/recomposeVApp"
          )
        end
      end
    end
  end
end
