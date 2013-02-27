require 'fog/core/collection'
require 'fog/hp/models/dns/domain'

module Fog
  module HP
    class DNS
      class Domains < Fog::Collection
        model Fog::HP::DNS::Domain

        def all
          data = connection.list_domains.body['domains']
          load(data)
        end

        def get(record_id)
          record = connection.get_domain_details(record_id).body['domain']
          new(flavor)
        rescue Fog::HP::DNS::NotFound
          nil
        end

      end
    end
  end
end


