require 'fog/core/collection'
require 'fog/cloudstack/models/compute/firewall'

module Fog
  module Compute
    class Cloudstack

      class Firewalls < Fog::Collection

        model Fog::Compute::Cloudstack::Firewall


      end

    end
  end
end
