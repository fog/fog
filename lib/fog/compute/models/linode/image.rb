require 'fog/core/model'

module Fog
  module Linode
    class Compute
      class Image < Fog::Model
        identity :id
        attribute :name
        attribute :bits
        attribute :kernel_id
        attribute :image_size

        def kernel
          Kernel.populate kernel_id
        end
      end
    end
  end
end
