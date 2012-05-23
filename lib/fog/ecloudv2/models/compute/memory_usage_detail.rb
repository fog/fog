module Fog
  module Compute
    class Ecloudv2
      class MemoryUsageDetail < Fog::Ecloudv2::Model
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
