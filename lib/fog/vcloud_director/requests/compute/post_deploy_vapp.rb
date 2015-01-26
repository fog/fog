module Fog
  module Compute
    class VcloudDirector
      class Real
        # Deploy a vApp or VM.
        #
        # Deployment allocates all resources for the vApp and the virtual
        # machines it contains.
        #
        # This operation is asynchronous and returns a task that you can
        # monitor to track the progress of the request.
        #
        # @param [String] id Object identifier of the vApp.
        # @param [Hash] options
        # @option options [Integer] :deploymentLeaseSeconds Lease in seconds
        #   for deployment. A value of 0 is replaced by the organization
        #   default deploymentLeaseSeconds value.
        # @option options [Boolean] :forceCustomization Used to specify whether
        #   to force customization on deployment, if not set default value is
        #   false.
        # @option options [Boolean] :powerOn Used to specify whether to power
        #   on vApp on deployment, if not set default value is true.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/POST-DeployVApp.html
        # @since vCloud API version 0.9
        def post_deploy_vapp(id, options={})
          body = Nokogiri::XML::Builder.new do
            attrs = {
              :xmlns => 'http://www.vmware.com/vcloud/v1.5'
            }
            attrs[:deploymentLeaseSeconds] = options[:deploymentLeaseSeconds] if options.key?(:deploymentLeaseSeconds)
            attrs[:forceCustomization] = options[:forceCustomization] if options.key?(:forceCustomization)
            attrs[:powerOn] = options[:powerOn] if options.key?(:powerOn)
            DeployVAppParams(attrs)
          end.to_xml

          request(
            :body    => body,
            :expects => 202,
            :headers => {'Content-Type' => 'application/vnd.vmware.vcloud.deployVAppParams+xml'},
            :method  => 'POST',
            :parser  => Fog::ToHashDocument.new,
            :path    => "vApp/#{id}/action/deploy"
          )
        end
      end
    end
  end
end
