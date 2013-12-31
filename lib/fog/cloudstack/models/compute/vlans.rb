require 'fog/core/collection'
require 'fog/cloudstack/models/compute/vlan'

module Fog
  module Compute
    class Cloudstack

      class Vlans < Fog::Collection

        model Fog::Compute::Cloudstack::Vlan


      end

    end
  end
end
