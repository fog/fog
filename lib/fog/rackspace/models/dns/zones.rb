require 'fog/core/collection'
require 'fog/rackspace/models/dns/zone'

module Fog
  module DNS
    class Rackspace
      class Zones < Fog::Collection

        model Fog::DNS::Rackspace::Zone

        def all
          clear
          data = service.list_domains.body['domains']
          load(data)
        end
        
        # Returns all domains containing the given substring. Still limited 
        # by the 100-domain pagination limit. Returns an empty array if
        # no matches.
        def find(substring)
          clear
          data = service.list_domains(:name => substring).body['domains']
          load(data)
        end

        def get(zone_id)
          if zone_id.nil? or zone_id.to_s.empty?
            return nil
          end

          data = service.list_domain_details(zone_id).body
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
