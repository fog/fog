require 'fog/core/collection'
require 'fog/dns/models/linode/zone'

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
          if data = connection.domain_list(zone_id).body['DATA'].first
            new(data)
          else
            nil
          end
        end

      end

    end
  end
end
