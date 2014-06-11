require 'fog/core/collection'
require 'fog/cloudsigma/models/server'

module Fog
  module Compute
    class CloudSigma
      class Servers < Fog::Collection
        model Fog::Compute::CloudSigma::Server

        def all
          resp = service.list_servers
          data = resp.body['objects']
          load(data)
        end

        def get(server_id)
          resp = service.get_server(server_id)
          data = resp.body
          new(data)
        rescue Fog::CloudSigma::Errors::NotFound
          return nil
        end
      end
    end
  end
end
