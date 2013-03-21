module Fog
  module Compute
    class Vsphere
      class Real
        def get_template(id, datacenter_name = nil)
          convert_vm_mob_ref_to_attr_hash(get_vm_ref(id, datacenter_name))
        end
      end

      class Mock
        def get_template(id, datacenter_name = nil)
        end
      end
    end
  end
end
