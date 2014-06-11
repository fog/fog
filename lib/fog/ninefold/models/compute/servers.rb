require 'fog/core/collection'
require 'fog/ninefold/models/compute/server'

module Fog
  module Compute
    class Ninefold
      class Servers < Fog::Collection
        model Fog::Compute::Ninefold::Server

        def all
          data = service.list_virtual_machines
          load(data)
        end

        def get(identifier)
          return nil if identifier.nil? || identifier == ""
          data = service.list_virtual_machines(:id => identifier)
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
