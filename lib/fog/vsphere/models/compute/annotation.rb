module Fog
  module Compute
    class Vsphere
      class Annotation < Fog::Model

        identity  :key
        attribute :value
        attr_accessor :vm

        def update val
          requires :vm, :key, :value
          val = val.to_s
          service.update_annotation vm.id, key, val
          self.value = val
        end
      end
    end
  end
end
