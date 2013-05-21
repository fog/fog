require 'fog/core/model'

module Fog
  module HP
    class LB
      class Algorithm < Fog::Model
        identity :name
      end
    end
  end
end
