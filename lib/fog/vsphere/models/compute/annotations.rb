require 'fog/vsphere/models/compute/annotation'

module Fog
  module Compute
    class Vsphere
      class Annotations < Fog::Collection
        model Fog::Compute::Vsphere::Annotation
        attr_accessor :vm

        def all
          self
        end
      end
    end
  end
end
