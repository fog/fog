module Fog
  module Compute
    class Vsphere
      class Real
        def set_vm_customvalue(vm_id, key, value)
          vm_ref = get_vm_ref(vm_id)
          vm_ref.setCustomValue(:key => key, :value => value)
        end
      end
      class Mock
        def set_vm_customvalue(vm_id, key, value)
          nil
        end
      end
    end
  end
end
