require 'fog/collection'
require 'fog/rackspace/models/servers/flavor'

module Fog
  module Rackspace
    module Servers

      class Real
        def flavors
          Fog::Rackspace::Servers::Flavors.new(:connection => self)
        end
      end

      class Mock
        def flavors
          Fog::Rackspace::Servers::Flavors.new(:connection => self)
        end
      end

      class Flavors < Fog::Collection

        model Fog::Rackspace::Servers::Flavor

        def all
          data = connection.list_flavors_detail.body['flavors']
          load(data)
        end

        def get(flavor_id)
          data = connection.get_flavor_details(flavor_id).body['flavor']
          new(data)
        rescue Excon::Errors::NotFound
          nil
        end

      end

    end
  end
end
