require 'fog/core/collection'
require 'fog/linode/models/dns/zone'

module Fog
  module Linode
    class DNS

      class Zones < Fog::Collection

        model Fog::Linode::DNS::Zone

        def all
          data = connection.domain_list.body['DATA']
          load(data)
        end

        def get(zone_id)
          data = connection.domain_list(zone_id).body['DATA']
          new(data)
        rescue Excon::Errors::Forbidden
          nil
        end

      end

    end
  end
end
