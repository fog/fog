module Fog
  class Slicehost

    def flavors
      Fog::Slicehost::Flavors.new(:connection => self)
    end

    class Flavors < Fog::Collection

      model Fog::Slicehost::Flavor

      def all
        data = connection.get_flavors.body['flavors']
        load(self)
      end

      def get(flavor_id)
        connection.get_flavor(flavor_id)
      rescue Excon::Errors::Forbidden
        nil
      end

    end

  end
end
