module Fog
  module Compute
    class DigitalOceanV2
      class Flavor < Fog::Model
        identity  :slug
        attribute :available
        attribute :transfer
        attribute :price_monthly
        attribute :price_hourly
        attribute :memory
        attribute :vcpus
        attribute :disk
        attribute :regions
      end
    end
  end
end