require 'fog/core/collection'
require 'fog/vcloud_director/models/compute/vm_network'

module Fog
  module Compute
    class VcloudDirector
      class VmNetworks < Collection
        model Fog::Compute::VcloudDirector::VmNetwork

        attribute :vm

        def get(id)
          data = service.get_vm_network(id).body
          new(data)
        end
      end
    end
  end
end
