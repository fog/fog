require 'fog/core/collection'
require 'fog/rackspace/models/databases/flavor'

module Fog
  module Rackspace
    class Databases
      class Flavors < Fog::Collection
        model Fog::Rackspace::Databases::Flavor

        def all
          data = service.list_flavors.body['flavors']
          load(data)
        end

        def get(flavor_id)
          data = service.get_flavor(flavor_id).body['flavor']
          new(data)
        rescue Fog::Rackspace::Databases::NotFound
          nil
        end
      end
    end
  end
end
