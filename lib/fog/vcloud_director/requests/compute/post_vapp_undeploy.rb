module Fog
  module Compute
    class VcloudDirector
      class Real

        def undeploy(vapp_id)
          body = <<EOF
                        <UndeployVAppParams xmlns="http://www.vmware.com/vcloud/v1.5">
                        <UndeployPowerAction>shutdown</UndeployPowerAction>
                        </UndeployVAppParams>
EOF

          request(
            :body    => body,
            :expects => 202,
            :method  => 'POST',
            :parser  => Fog::ToHashDocument.new,
            :headers => {'Content-Type' => 'application/vnd.vmware.vcloud.undeployVAppParams+xml' },
            :path    => "vApp/#{vapp_id}/action/undeploy"
          )
        end

      end
    end
  end
end
