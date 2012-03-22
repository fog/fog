require 'fog/core/collection'
require 'fog/ibm/models/compute/instance-type'

module Fog
  module Compute
    class IBM

      class InstanceTypes < Fog::Collection

        model Fog::Compute::IBM::InstanceType

      end
    end
  end
end
