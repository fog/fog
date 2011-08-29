require 'fog/core/collection'
require 'fog/rackspace/models/dns/zone'

module Fog
  module DNS
    class Rackspace
      class Zones < Fog::Collection

        model Fog::DNS::Rackspace::Zone

        def all
          clear
          data = connection.list_domains.body['domains']
          load(data)
        end

        def get(zone_id)
          if zone_id.nil? or zone_id.to_s.empty?
            return nil
          end

          data = connection.list_domain_details(zone_id).body
          new(data)
        rescue Fog::Rackspace::Errors::NotFound
          nil
        #Accessing a valid (but other customer's) id returns a 503 error
        rescue Fog::Rackspace::Errors::ServiceUnavailable
          nil
        end
      end
    end
  end
end
