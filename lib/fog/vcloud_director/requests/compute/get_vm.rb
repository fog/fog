module Fog
  module Compute
    class VcloudDirector
      class Real
        require 'fog/vcloud_director/parsers/compute/vm'
        
        def get_vm(vm_id)
          request(
            :expects  => 200,
            :method   => 'GET',
            :parser => Fog::Parsers::Compute::VcloudDirector::Vm.new,
            :path     => "vApp/#{vm_id}"
          )
        end

      end
    end
  end
end
