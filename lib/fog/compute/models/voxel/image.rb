require 'fog/core/model'

module Fog
  module Voxel
    class Compute
      class Image < Fog::Model

        identity :id

        attribute :summary

      end
    end
  end
end
