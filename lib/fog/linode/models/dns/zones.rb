require 'fog/core/collection'
require 'fog/linode/models/dns/zone'

module Fog
  module DNS
    class Linode
      class Zones < Fog::Collection
        model Fog::DNS::Linode::Zone

        def all
          data = service.domain_list.body['DATA']
          load(data)
        end

        def get(zone_id)
          if data = service.domain_list(zone_id).body['DATA'].first
            new(data)
          else
            nil
          end
        end
      end
    end
  end
end
