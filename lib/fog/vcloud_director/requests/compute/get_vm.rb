module Fog
  module Compute
    class VcloudDirector
      class Real
        require 'fog/vcloud_director/parsers/compute/vm'

        # Retrieve a vApp or VM.
        #
        # @param [String] vm_id
        # @return [Excon::Response]
        #   * body<~Hash>:
        # @see #get_vapp
        def get_vm(vm_id)
          request(
            :expects => 200,
            :method  => 'GET',
            :parser  => Fog::Parsers::Compute::VcloudDirector::Vm.new,
            :path    => "vApp/#{vm_id}"
          )
        end
      end
    end
  end
end
