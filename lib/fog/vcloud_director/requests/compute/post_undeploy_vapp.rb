module Fog
  module Compute
    class VcloudDirector
      class Real
        # Undeploy a vApp/VM.
        #
        # Undeployment deallocates all resources used by the vApp and the VMs
        # it contains.
        #
        # This operation is asynchronous and returns a task that you can
        # monitor to track the progress of the request.
        #
        # @param [String] id Object identifier of the vApp.
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
        #
        # @raise [Fog::Compute::VcloudDirector::BadRequest]
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/POST-UndeployVApp.html
        # @since vCloud API version 0.9
        def post_undeploy_vapp(id, options={})
          body = Nokogiri::XML::Builder.new do
            attrs = {
              :xmlns => 'http://www.vmware.com/vcloud/v1.5'
            }
            UndeployVAppParams(attrs) {
              if options[:UndeployPowerAction]
                UndeployPowerAction options[:UndeployPowerAction]
              end
            }
          end.to_xml

          request(
            :body    => body,
            :expects => 202,
            :headers => {'Content-Type' => 'application/vnd.vmware.vcloud.undeployVAppParams+xml'},
            :method  => 'POST',
            :parser  => Fog::ToHashDocument.new,
            :path    => "vApp/#{id}/action/undeploy"
          )
        end

        # @deprecated Use {#post_undeploy_vapp} instead.
        def undeploy(id)
          Fog::Logger.deprecation("#{self} => ##{undeploy} is deprecated, use ##{post_undeploy_vapp} instead [light_black](#{caller.first})[/]")
          post_undeploy_vapp(id, :UndeployPowerAction => 'shutdown')
        end
      end
    end
  end
end
