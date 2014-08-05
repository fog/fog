module Fog
  module Compute
    class Vsphere
      class Real
        def list_vm_customvalues(vm_id)
          get_vm_ref(vm_id).summary.customValue.map do |customvalue|
            {
              :key    => customvalue.key.to_i,
              :value  => customvalue.value,
            }
          end
        end
      end
      class Mock
        def list_vm_customfields(vm_id)
        end
      end
    end
  end
end
