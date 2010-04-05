require 'fog/collection'
require 'fog/slicehost/models/flavor'

module Fog
  module Slicehost

    class Mock
      def flavors
        Fog::Slicehost::Flavors.new(:connection => self)
      end
    end

    class Real
      def flavors
        Fog::Slicehost::Flavors.new(:connection => self)
      end
    end

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
