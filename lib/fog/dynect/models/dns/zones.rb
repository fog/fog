require 'fog/core/collection'
require 'fog/dynect/models/dns/zone'

module Fog
  module DNS
    class Dynect

      class Zones < Fog::Collection

        model Fog::DNS::Dynect::Zone

        def all
          data = service.get_zone.body['data'].map do |zone|
            { :domain => zone }
          end
          load(data)
        end

        def get(zone_id)
          new(service.get_zone('zone' => zone_id).body['data'])
        rescue Excon::Errors::NotFound
          nil
        end

      end

    end
  end
end
