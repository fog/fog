require 'fog/core/collection'
require 'fog/ibm/models/compute/server'

module Fog
  module Compute
    class IBM
      class Servers < Fog::Collection
        model Fog::Compute::IBM::Server

        def all
          load(service.list_instances.body['instances'])
        end

        def get(server_id)
          begin
            new(service.get_instance(server_id).body)
          rescue Fog::Compute::IBM::NotFound
            nil
          end
        end
      end
    end
  end
end
