module Fog
  module Compute
    class Vsphere
      class Real
        def update_annotation(vm_id, key, val)
          get_vm_ref(vm_id).setCustomValue(:key => key, :value => val)
        end
      end

      class Mock

        def update_annotation(vm_id, key, val)
        end
      end
    end
  end
end
