require 'fog/core/model'

module Fog
  module Compute
    class DigitalOcean
      class Region < Fog::Model
        identity  :id
        attribute :name
      end
    end
  end
end
