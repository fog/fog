require 'fog/core/model'

module Fog
  module Compute
    class Bluebox

      class Location < Fog::Model

        identity :id
        
        attribute :description

      end

    end
  end
end
