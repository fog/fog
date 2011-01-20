require 'fog/core/model'

module Fog
  module Voxel
    class Compute
      class Image < Fog::Model
        identity :id
        attribute :name
      end
    end
  end
end
