module Fog
  module Compute
    class DigitalOceanV2
      class Image < Fog::Model
        identity :id
        attribute :name
        attribute :type
        attribute :distribution
        attribute :slug
        attribute :public
        attribute :regions
        attribute :min_disk_size
        attribute :created_at
      end
    end
  end
end