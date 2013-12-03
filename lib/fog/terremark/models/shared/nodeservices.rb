require 'fog/core/collection'
require 'fog/terremark/models/shared/nodeservice'

module Fog
  module Terremark
    module Shared

      module Mock
        def nodeservices(options = {})
          Fog::Terremark::Shared::Servers.new(options.merge(:service => self))
        end
      end

      module Real
        def nodeservices(options = {})
          Fog::Terremark::Shared::NodeServices.new(options.merge(:service => self))
        end
      end

      class NodeServices < Fog::Collection

        model Fog::Terremark::Shared::NodeService

        def all(internet_service_id)
          data = service.get_node_services(internet_service_id).body["NodeServices"]
          load(data)
        end

      end
    end
  end
end
