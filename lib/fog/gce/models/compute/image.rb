require 'fog/core/model'

module Fog
  module Compute
    class GCE

      class Image < Fog::Model

        identity :name

        attribute :kind
        attribute :creation_timestamp, :aliases => 'creationTimestamp'
        attribute :description
        attribute :preferred_kernel, :aliases => 'preferredKernel'

      end
    end
  end
end
