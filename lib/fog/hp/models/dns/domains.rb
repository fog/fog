require 'fog/core/collection'
require 'fog/hp/models/dns/domains'

module Fog
  module HP
    class DNS

      class Domains < Fog::Collection

        attribute :filters

        model Fog::HP::DNS::Domains

        def initialize(attributes)
          self.filters ||= {}
          super
        end

        def all(filters = filters)
          self.filters = filters
          non_aliased_filters = Fog::HP.convert_aliased_attributes_to_original(self.model, filters)
          load(service.list_domains(non_aliased_filters).body['domains'])
        end

        def get(domain_id)
          if domain = service.get_domain(domain_id).body['domain']
            new(domain)
          end
        rescue Fog::HP::DNS::NotFound
          nil
        end

      end
    end
  end
end
