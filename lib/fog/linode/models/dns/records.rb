require 'fog/core/collection'
require 'fog/linode/models/dns/record'

module Fog
  module DNS
    class Linode

      class Records < Fog::Collection

        attribute :zone

        model Fog::DNS::Linode::Record

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
