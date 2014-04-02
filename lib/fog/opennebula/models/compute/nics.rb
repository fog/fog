require 'fog/core/collection'
require 'fog/opennebula/models/compute/nic'

module Fog
  module Compute
    class OpenNebula

      class Nics < Fog::Collection

        model Fog::Compute::OpenNebula::Nic

      end

    end
  end
end
