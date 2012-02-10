require 'fog/core/collection'
require 'fog/joyent/models/compute/server'

module Fog
  module Compute

    class Joyent
      class Servers < Fog::Collection
        model Fog::Compute::Joyent::Server

        def all
          load(self.connection.list_machines().body)
        end

        def create(params = {})
          data = self.connection.create_machine(params).body
          server = new(data)
          server.wait_for { ready? }
          server
        end

        def bootstrap
          # XXX TOXO
        end

        def get(machine_id)
          data = self.connection.get_machine(machine_id).body
          new(data)
        end

      end
    end # Joyent

  end # Compute
end # Fog
