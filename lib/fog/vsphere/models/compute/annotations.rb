require 'fog/vsphere/models/compute/annotation'

module Fog
  module Compute
    class Vsphere
      class Annotations < Fog::Collection
        model Fog::Compute::Vsphere::Annotation

        def set_vm_for_each_annotation vm
          self.each do |annotation|
            annotation.vm = vm
          end
        end

        def all
          self
        end
      end
    end
  end
end
