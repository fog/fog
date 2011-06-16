require 'fog/core/model'

module Fog
  module Compute
    class Voxel
      class Image < Fog::Model

        identity :id

        attribute :summary

      end
    end
  end
end
