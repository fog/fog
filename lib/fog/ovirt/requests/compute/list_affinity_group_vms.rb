module Fog
  module Compute
    class Ovirt
      class Real
        def list_affinity_group_vms(id)
          client.affinity_group_vms(id).collect {|vm| servers.get(vm.id)}
        end
      end

      class Mock
        def list_affinity_group_vms(id)
          nil
        end
      end
    end
  end
end
