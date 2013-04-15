module Fog
  module Compute
    class Vsphere
      class Annotation < Fog::Model

        identity  :key
        attribute :value

        def update val
          val = val.to_s
          collection.vm.raw_vm.setCustomValue(:key => key, :value => val)
          self.value = val
        end
      end
    end
  end
end
