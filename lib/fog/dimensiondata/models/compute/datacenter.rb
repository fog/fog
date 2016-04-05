module Fog
  module Compute
    class DimensionData
      class Datacenter < Fog::Model
        identity :id

        attribute :type
        attribute :displayName
        attribute :city
        attribute :state
        attribute :country
        attribute :vpnUrl
        attribute :ftpsUrl
      end
    end
  end
end
