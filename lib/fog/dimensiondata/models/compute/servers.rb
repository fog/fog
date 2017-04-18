require 'fog/core/collection'
require 'fog/dimensiondata/models/compute/server'

module Fog
  module Compute
    class DimensionData
      class Servers < Fog::Collection
        model Fog::Compute::DimensionData::Server

        def all
          load(service.list_machines().body)
        end

        def create(params = {})
          data = service.create_machine(params).body
          server = new(data)
          server
        end

        def bootstrap(new_attributes = {})
          server = create(new_attributes)
          server.wait_for { ready? }
          server
        end

        def get(machine_id)
          data = service.get_machine(machine_id).body
          server = new(data)
          server.tags = server.list_tags if server.tags.nil?
          server
        end
      end
    end # DimensionData
  end # Compute
end # Fog
