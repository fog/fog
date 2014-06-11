require 'fog/core/collection'
require 'fog/rage4/models/dns/zone'

module Fog
  module DNS
    class Rage4
      class Zones < Fog::Collection
        model Fog::DNS::Rage4::Zone

        def all
          clear
          data = service.list_domains.body
          load(data)
        end

        def get(zone_name)
          data = service.get_domain_by_name(zone_name).body

          if data["status"] && !data["status"]
            nil
          else
            new(data)
          end
        rescue Excon::Errors::NotFound
          nil
        end
      end
    end
  end
end
