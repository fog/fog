require 'fog/core/collection'
require 'fog/opennebula/models/compute/interface'

module Fog
  module Compute
    class OpenNebula
      class Interfaces < Fog::Collection
        model Fog::Compute::OpenNebula::Interface
      end
    end
  end
end
