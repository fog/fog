require 'fog/core/collection'
require 'fog/compute/models/ninefold/server'

module Fog
  module Ninefold
    class Compute

      class Servers < Fog::Collection

        model Fog::Ninefold::Compute::Server

        def all
          data = connection.list_virtual_machines
          load(data)
        end

        def get(identifier)
          return nil if identifier.nil? || identifier == ""
          data = connection.list_virtual_machines(:id => identifier)
          if data.empty?
            nil
          else
            new(data[0])
          end
        end

      end

    end
  end
end
