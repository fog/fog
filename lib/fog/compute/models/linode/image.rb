require 'fog/core/model'

module Fog
  module Linode
    class Compute
      class Image < Fog::Model
        identity :id
        attribute :name
        attribute :bits
        attribute :image_size
      end
    end
  end
end
