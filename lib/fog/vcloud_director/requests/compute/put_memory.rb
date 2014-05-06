module Fog
  module Compute
    class VcloudDirector
      class Real
        extend Fog::Deprecation
        deprecate :put_vm_memory, :put_memory

        require 'fog/vcloud_director/generators/compute/memory_item'

        # Update the RASD item that specifies memory properties of a VM.
        #
        # This operation is asynchronous and returns a task that you can
        # monitor to track the progress of the request.
        #
        # @param [String] id Object identifier of the VM.
        # @param [Integer] memory Memory size in Megabytes.
        # @return [Excon::Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/PUT-Memory.html
        # @since vCloud API version 0.9
        def put_memory(id, memory)
          data = Fog::Generators::Compute::VcloudDirector::MemoryItem.new.generate_xml(id, memory, end_point)

          request(
            :body    => data,
            :expects => 202,
            :headers => {'Content-Type' => 'application/vnd.vmware.vcloud.rasdItem+xml'},
            :method  => 'PUT',
            :parser  => Fog::ToHashDocument.new,
            :path    => "vApp/#{id}/virtualHardwareSection/memory"
          )
        end
      end
    end
  end
end
