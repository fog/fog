module Fog
  module Compute
    class VcloudDirector
      class Real

        require 'fog/vcloud_director/parsers/compute/vm_network'

        def get_vm_network(vm_id)
          request(
            :expects => 200,
            :method  => 'GET',
            :parser  => Fog::Parsers::Compute::VcloudDirector::VmNetwork.new,
            :path    => "vApp/#{vm_id}/networkConnectionSection/"
          )
        end

      end
    end
  end
end
