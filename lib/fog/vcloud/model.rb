module Fog
  module Vcloud
    class Model < Fog::Model

      attr_accessor :loaded
      alias_method :loaded?, :loaded

      def reload
        super
        @loaded = true
      end

      def load_unless_loaded!
        unless @loaded
          reload
        end
      end

    end
  end
end
