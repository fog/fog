require 'fog/core/model'

module Fog
  module Compute
    class DigitalOcean
      class Flavor < Fog::Model
        identity  :id
        attribute :name
      end
    end
  end
end
