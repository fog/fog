require 'fog/core/collection'
require 'fog/hp/models/dns/domain'

module Fog
  module HP
    class DNS
      class Domains < Fog::Collection
        model Fog::HP::DNS::Domain

        def all
          load(service.list_domains.body['domains'])
        end

        def get(domain_id)
          ### Inconsistent API - does not return a 'domain'
          if domain = service.get_domain(domain_id).body
            new(domain)
          end
        rescue Fog::HP::DNS::NotFound
          nil
        end
      end
    end
  end
end
