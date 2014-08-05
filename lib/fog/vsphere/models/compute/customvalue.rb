module Fog
  module Compute
    class Vsphere
      class Customvalue < Fog::Model
        attribute :value
        attribute :key

        def to_s
          value
        end
      end
    end
  end
end
