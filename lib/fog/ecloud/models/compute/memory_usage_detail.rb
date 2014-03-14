module Fog
  module Compute
    class Ecloud
      class MemoryUsageDetail < Fog::Ecloud::Model
        identity :href

        attribute :time, :aliases => :Time
        attribute :value, :aliases => :Value

        def id
          href.scan(/\d+/)[0]
        end
      end
    end
  end
end
