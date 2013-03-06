require 'fog/core/model'

module Fog
  module HP
    class LB
      class Protocol < Fog::Model
        identity :name
        attribute :port
      end
    end
  end
end