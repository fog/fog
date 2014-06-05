require 'fog/core/collection'
require 'fog/storm_on_demand/models/dns/domain'

module Fog
  module DNS
    class StormOnDemand
      class Domains < Fog::Collection
        model Fog::DNS::StormOnDemand::Domain

        def all(options={})
          domains = service.list_domains(options).body['items']
          load(domains)
        end
      end
    end
  end
end
