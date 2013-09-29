module Fog
  module Compute
    class VcloudDirector
      class Real
        # Undeploy a vApp/VM.
        #
        # Undeployment deallocates all resources used by the vApp and the VMs it contains.
        #
        # This operation is asynchronous and returns a task that you can
        # monitor to track the progress of the request.
        #
        # @param [String] vapp_id
        # @return [Excon::Response]
        #   * body<~Hash>:
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/POST-UndeployVApp.html
        #   vCloud API Documentation
        # @since vCloud API version 0.9
        def undeploy(vapp_id)
          body = <<EOF
                        <UndeployVAppParams xmlns="http://www.vmware.com/vcloud/v1.5">
                        <UndeployPowerAction>shutdown</UndeployPowerAction>
                        </UndeployVAppParams>
EOF

          request(
            :body    => body,
            :expects => 202,
            :headers => {'Content-Type' => 'application/vnd.vmware.vcloud.undeployVAppParams+xml' },
            :method  => 'POST',
            :parser  => Fog::ToHashDocument.new,
            :path    => "vApp/#{vapp_id}/action/undeploy"
          )
        end
      end
    end
  end
end
