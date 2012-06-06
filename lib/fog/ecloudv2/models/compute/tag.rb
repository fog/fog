module Fog
  module Compute
    class Ecloudv2
      class Tag < Fog::Ecloudv2::Model
        identity :name

        def id
          href.scan(/\d+/)[0]
        end
      end
    end
  end
end
