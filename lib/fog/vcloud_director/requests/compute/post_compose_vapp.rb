module Fog
  module Compute
    class VcloudDirector
      class Real
        require 'fog/vcloud_director/generators/compute/compose_vapp'
        # Compose a vApp from existing virtual machines.
        #
        # This operation is asynchronous and returns a task that you can
        # monitor to track the progress of the request.
        #
        # @param [String] id Object identifier of the vdc.
        # @param [Hash] options
        # @option options [Boolean] :powerOn Used to specify whether to power
        #   on vApp on deployment, if not set default value is true.
        # @option options [Boolean] :deploy Used to specify whether to deploy
        #   the vApp, if not set default value is true.
        # @option options [String] :name Used to identify the vApp.
        # @option options [String] :networkName Used to conect the vApp and VMs to a VDC network, which has
        # to exist beforehand.
        # @option options [String] :networkHref Used to conect the vApp and VMs to a VDC network, which has
        # to exist beforehand.
        # @option options [String] :fenceMode Used to configure the network Mode (briged, isolated).
        # @option options [String] :source_vms Array with VMs to be used to compose the vApp, each containing -
        # :name, :href, :isGuestCustomizationEnabled, :computer_name and :ipAllocationMode (e.g. 'DHCP').
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/POST-ComposeVApp.html
        # @since vCloud API version 0.9
        def post_compose_vapp(id, options={})
          body = Fog::Generators::Compute::VcloudDirector::ComposeVapp.new(options).generate_xml

          request(
            :body => body,
            :expects => 201,
            :headers => {'Content-Type' => 'application/vnd.vmware.vcloud.composeVAppParams+xml'},
            :method => 'POST',
            :parser => Fog::ToHashDocument.new,
            :path => "vdc/#{id}/action/composeVApp"
          )
        end
      end
    end
  end
end
