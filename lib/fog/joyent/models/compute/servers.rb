require 'fog/core/collection'
require 'fog/joyent/models/compute/server'

module Fog
  module Compute

    class Joyent
      class Servers < Fog::Collection
        model Fog::Compute::Joyent::Server

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
          new(data)
        end

      end
    end # Joyent

  end # Compute
end # Fog
