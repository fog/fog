module Fog
  module Compute
    class Ecloud
      class Tag < Fog::Ecloud::Model
        identity :name

        def id
          href.scan(/\d+/)[0]
        end
      end
    end
  end
end
