require 'fog/collection'
require 'fog/slicehost/models/flavor'

module Fog
  class Slicehost

    class Flavors < Fog::Collection

      model Fog::Slicehost::Flavor

      def all
        data = connection.get_flavors.body['flavors']
        load(data)
      end

      def get(flavor_id)
        connection.get_flavor(flavor_id)
      rescue Excon::Errors::Forbidden
        nil
      end

    end

  end
end
