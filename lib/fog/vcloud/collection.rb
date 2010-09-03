module Fog
  class Vcloud
    class Collection < Fog::Collection

      def load(objects)
        objects = [ objects ] if objects.is_a?(Hash)
        super
      end

    end
  end
end
