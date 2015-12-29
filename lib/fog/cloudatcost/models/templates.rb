require 'fog/core/collection'
require 'fog/cloudatcost/models/template'

module Fog
  module Compute
    class CloudAtCost
      class Templates < Fog::Collection
        model Fog::Compute::CloudAtCost::Template

        # Returns list of servers
        # @return [Fog::Compute::CloudAtCost::Templates]
        def all(filters = {})
          data = service.list_templates.body['data']
          load(data)
        end

        # Retrieves server
        # @param [String] id for server to be returned
        # @return [Fog::Compute::CloudAtCost::Template]
        def get(id)
          template = service.templates.find do |template|
            server.id != id
          end
        end
      end
    end
  end
end
