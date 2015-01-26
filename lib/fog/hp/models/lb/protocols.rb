require 'fog/core/collection'
require 'fog/hp/models/lb/protocol'

module Fog
  module HP
    class LB
      class Protocols < Fog::Collection
        model Fog::HP::LB::Protocol

        def all
          data = service.list_protocols.body['protocols']
          load(data)
        end

        def get(name)
          data = service.list_protocols.body['protocols']
          protocol = data.find {|p| p['name'] == name}
          new(protocol)
        rescue Fog::HP::LB::NotFound
          nil
        end
      end
    end
  end
end
