module Fog
  module Compute
    class VcloudDirector
      class Real

        require 'fog/vcloud_director/generators/compute/vm'

        # Update the name, description and storage profile for VM.
        #
        # This operation is asynchronous and returns a task that you can
        # monitor to track the progress of the request.
        #
        # @param [String] id Object identifier of the VM.
        # @param [String] name of the VM.
        # @param [Hash] options
        #   * :Description<~String>: - description to be assigned.
        #   * :StorageProfile<~Hash>: - storage profile to be assigned.
        #     * :name<~String>
        #     * :href<~String>
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/PUT-Vm.html
        # @since vCloud API version 0.9
        def put_vm(id, name, options)
          body = Fog::Generators::Compute::VcloudDirector::Vm.new(options.merge(:name => name)).generate_xml
          request(
            :body    => body,
            :expects => 202,
            :headers => {'Content-Type' => 'application/vnd.vmware.vcloud.vm+xml'},
            :method  => 'PUT',
            :parser  => Fog::ToHashDocument.new,
            :path    => "vApp/#{id}"
          )
        end
      end
    end
  end
end
