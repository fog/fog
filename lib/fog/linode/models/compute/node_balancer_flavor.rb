require 'fog/core/model'

module Fog
  module Compute
    class Linode
      class NodeBalancerFlavor < Fog::Model
        attribute :price_monthly
        attribute :price_hourly
        attribute :connections
      end
    end
  end
end
