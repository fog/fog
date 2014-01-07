require 'fog/core/collection'
require 'fog/cloudstack/models/compute/nat'

module Fog
  module Compute
    class Cloudstack

      class Nats < Fog::Collection

        model Fog::Compute::Cloudstack::Nat


      end

    end
  end
end
