require 'fog/vsphere/models/compute/annotation'

module Fog
  module Compute
    class Vsphere
      class Annotations < Fog::Collection
        model Fog::Compute::Vsphere::Annotation
      end
    end
  end
end
