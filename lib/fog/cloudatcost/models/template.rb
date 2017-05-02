module Fog
  module Compute
    class CloudAtCost
      class Template < Fog::Model
        identity :id
        attribute :detail
      end
    end
  end
end
