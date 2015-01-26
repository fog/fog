require 'fog/core/collection'
require 'fog/libvirt/models/compute/nic'

module Fog
  module Compute
    class Libvirt
      class Nics < Fog::Collection
        model Fog::Compute::Libvirt::Nic
      end
    end
  end
end
