require 'fog/core/colletion'
require 'fog/storm_on_demand/models/dns/reverse'

module Fog
  module DNS
    class StormOnDemand

      class Reverses < Fog::Collection
        model Fog::DNS::StormOnDemand::Reverse

        def destroy(options)
          service.delete_reverse(options).body
        end

        def update(options)
          service.update_reverse(options).body
        end

      end

    end
  end
end
