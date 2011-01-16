require 'fog/core/collection'
require 'fog/dns/models/linode/record'

module Fog
  module Linode
    class DNS

      class Records < Fog::Collection

        attribute :zone

        model Fog::Linode::DNS::Record

        def all
          requires :zone
          data = connection.domain_resource_list(zone.id).body['DATA']
          load(data)
        end

        def get(record_id)
          if data = connection.domain_resource_list(zone.id, record_id).body['DATA'].first
            new(data)
          else
            nil
          end
        end

        def new(attributes = {})
          requires :zone
          super({ :zone => zone }.merge!(attributes))
        end

      end

    end
  end
end
