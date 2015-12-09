require 'fog/core/model'

module Fog
  module Compute
    class Linode
      class Image < Fog::Model
        identity :id
        attribute :name
        attribute :bits
        attribute :image_size
        attribute :created_at, types: 'time'
        attribute :requires_pvops_kernel
      end
    end
  end
end
