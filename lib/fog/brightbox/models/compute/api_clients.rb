require "fog/core/collection"
require "fog/brightbox/models/compute/api_client"

module Fog
  module Compute
    class Brightbox
      class ApiClients < Fog::Collection
        model Fog::Compute::Brightbox::ApiClient

        def all
          data = service.list_api_clients
          load(data)
        end

        def get(identifier = nil)
          data = service.get_api_client(identifier)
          new(data)
        rescue Excon::Errors::NotFound
          nil
        end
      end
    end
  end
end
