module Fog
  module Compute
    class VcloudDirector
      class Real
        require 'fog/vcloud_director/generators/compute/undeploy_vapp_params'

        # Undeploy a vApp/VM.
        #
        # Undeployment deallocates all resources used by the vApp and the VMs it contains.
        #
        # This operation is asynchronous and returns a task that you can
        # monitor to track the progress of the request.
        #
        # @param [String] vapp_id Object identifier of the vApp.
        # @param [Hash] options
        # @option options [String] :UndeployPowerAction The specified action is
        #   applied to all virtual machines in the vApp. All values other than
        #   default ignore actions, order, and delay specified in the
        #   StartupSection. One of:
        #   - powerOff (Power off the virtual machines. This is the default
        #     action if this attribute is missing or empty)
        #   - suspend (Suspend the virtual machines)
        #   - shutdown (Shut down the virtual machines)
        #   - force (Attempt to power off the virtual machines. Failures in
        #     undeploying the virtual machine or associated networks are
        #     ignored.  All references to the vApp and its virtual machines are
        #     removed from the database)
        #   - default (Use the actions, order, and delay specified in the
        #     StartupSection).
        # @return [Excon::Response]
        #   * body<~Hash>:
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/POST-UndeployVApp.html
        #   vCloud API Documentation
        # @since vCloud API version 0.9
        def post_undeploy_vapp(vapp_id, options={})
          body = Fog::Generators::Compute::VcloudDirector::UndeployVappParams.new(options)

          request(
            :body    => body.to_xml,
            :expects => 202,
            :headers => {'Content-Type' => 'application/vnd.vmware.vcloud.undeployVAppParams+xml'},
            :method  => 'POST',
            :parser  => Fog::ToHashDocument.new,
            :path    => "vApp/#{vapp_id}/action/undeploy"
          )
        end

        # @deprecated Use {#post_undeploy_vapp} instead.
        def undeploy(vapp_id)
          Fog::Logger.deprecation("#{self} => ##{undeploy} is deprecated, use ##{post_undeploy_vapp} instead [light_black](#{caller.first})[/]")
          post_undeploy_vapp(vapp_id, :UndeployPowerAction => 'shutdown')
        end
      end
    end
  end
end
