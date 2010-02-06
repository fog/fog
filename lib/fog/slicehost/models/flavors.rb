module Fog
  class Slicehost

    def flavors
      Fog::Slicehost::Flavors.new(:connection => self)
    end

    class Flavors < Fog::Collection

      model Fog::Slicehost::Flavor

      def all
        if @loaded
          clear
        end
        @loaded = true
        data = connection.get_flavors.body
        for flavor in data['flavors']
          self << new(flavor)
        end
        self
      end

      def get(flavor_id)
        connection.get_flavor(flavor_id)
      rescue Excon::Errors::Forbidden
        nil
      end

    end

  end
end
