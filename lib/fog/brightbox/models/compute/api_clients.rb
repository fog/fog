require "fog/core/collection"
require "fog/brightbox/models/compute/api_client"

module Fog
  module Compute
    class Brightbox
      class ApiClients < Fog::Collection
        model Fog::Compute::Brightbox::ApiClient

        def all
          data = connection.list_api_clients
          load(data)
        end

        def get(identifier = nil)
          data = connection.get_api_client(identifier)
          new(data)
        rescue Excon::Errors::NotFound
          nil
        end
      end
    end
  end
end
