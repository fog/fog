module Fog
  module Compute
    class VcloudDirector
      class Real
        require 'fog/vcloud_director/generators/compute/create_snapshot'
        def post_create_snapshot(id, options={})
          body = Fog::Generators::Compute::VcloudDirector::CreateSnapshot.new(options).generate_xml

          request(
            :body => body,
            :expects => 202,
            :headers => { 'Content-Type' => 'application/vnd.vmware.vcloud.createSnapshotParams+xml' },
            :method => 'POST',
            :parser => Fog::ToHashDocument.new,
            :path => "vApp/#{id}/action/createSnapshot"
          )
        end
      end
    end
  end
end
