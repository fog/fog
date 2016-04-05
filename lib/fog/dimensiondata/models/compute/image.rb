module Fog
  module Compute
    class DimensionData
      class Image < Fog::Model
        identity :id

        attribute :name
        attribute :description
        attribute :memoryGb
        attribute :createTime, :type => :time
        attribute :default, :type => :boolean
      end
    end
  end
end
