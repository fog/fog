require 'fog/core/collection'
require 'fog/hp/models/lb/protocol'

module Fog
  module HP
    class LB
      class Protocols < Fog::Collection
        model Fog::HP::LB::Protocol

        def all
          data = connection.list_protocols.body['protocols']
          load(data)
        end

        def get(record_id)
          record = connection.get_protocol_details(record_id).body['protocol']
          new(record)
        rescue Fog::HP::LB::NotFound
          nil
        end

      end
    end
  end
end