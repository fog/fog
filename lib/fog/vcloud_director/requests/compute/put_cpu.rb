module Fog
  module Compute
    class VcloudDirector
      class Real
        extend Fog::Deprecation
        deprecate :put_vm_cpu, :put_cpu

        require 'fog/vcloud_director/generators/compute/cpu_item'

        # Update the RASD item that specifies CPU properties of a VM.
        #
        # This operation is asynchronous and returns a task that you can
        # monitor to track the progress of the request.
        #
        # @param [String] id Object identifier of the VM.
        # @param [Integer] num_cpus
        # @return [Excon:Response]
        #   * body<~Hash>:
        #
        # @see http://pubs.vmware.com/vcd-51/topic/com.vmware.vcloud.api.reference.doc_51/doc/operations/PUT-Cpu.html
        # @since vCloud API version 0.9
        def put_cpu(id, num_cpus)
          data = Fog::Generators::Compute::VcloudDirector::CpuItem.new.generate_xml(id, num_cpus, end_point)

          request(
            :body    => data,
            :expects => 202,
            :headers => {'Content-Type' => 'application/vnd.vmware.vcloud.rasdItem+xml'},
            :method  => 'PUT',
            :parser  => Fog::ToHashDocument.new,
            :path    => "vApp/#{id}/virtualHardwareSection/cpu"
          )
        end
      end
    end
  end
end
