require 'fog/core/model'

module Fog
  module DNS
    class StormOnDemand
      class Reverse < Fog::Model

        def initialize(attributes={})
          super
        end

        def destroy(options)
          service.delete_reverse(options).body
        end

        def update(options)
          service.update_reverse(options).body
        end

      end
    end
  end
end
