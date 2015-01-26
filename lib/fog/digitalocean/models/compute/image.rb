require 'fog/core/model'

module Fog
  module Compute
    class DigitalOcean
      class Image < Fog::Model
        identity  :id
        attribute :name
        attribute :distribution
      end
    end
  end
end
