require 'fog/core/collection'
require 'fog/dns/models/aws/zone'

module Fog
  module AWS
    class DNS

      class Zones < Fog::Collection

        attribute :marker,    :aliases => 'Marker'
        attribute :max_items, :aliases => 'MaxItems'

        model Fog::AWS::DNS::Zone

        def all(options = {})
          options['marker']   ||= marker
          options['maxitems'] ||= max_items
          data = connection.list_hosted_zones(options).body['HostedZones']
          load(data)
        end

        def get(zone_id)
          data = connection.get_hosted_zone(zone_id).body
          new(data)
        rescue Excon::Errors::BadRequest
          nil
        end

      end

    end
  end
end
