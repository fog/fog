require 'fog/core/collection'
require 'fog/dns/models/dynect/zone'

module Fog
  module Dynect
    class DNS

      class Zones < Fog::Collection

        model Fog::Dynect::DNS::Zone

        def all
        end

        def get(zone_id)
        end

      end

    end
  end
end
