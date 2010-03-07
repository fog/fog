module Fog
  module Rackspace
    class Servers

      def flavors
        Fog::Rackspace::Servers::Flavors.new(:connection => self)
      end

      class Flavors < Fog::Collection

        model Fog::Rackspace::Servers::Flavor

        def all
          data = connection.list_flavors_detail.body['flavors']
          load(data)
        end

        def get(flavor_id)
          connection.get_flavor_details(flavor_id)
        rescue Excon::Errors::NotFound
          nil
        end

      end

    end
  end
end
