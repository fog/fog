module Fog
  module Rackspace
    class ServiceCatalog
      def initialize(raw)
        @raw = raw
      end

      def find_by_type(type)
        res = @raw.find_all { |h| h["type"] == type }
        if res.size == 1
          res[0]
        elsif res.size == 0
          nil
        else
          res
        end
      end

      def to_a
        @raw
      end
    end
  end
end
