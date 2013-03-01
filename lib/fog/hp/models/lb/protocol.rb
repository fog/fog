require 'fog/core/model'

module Fog
  module HP
    class LB
      class Protocol
        identifier :name
        attribute :port
      end
    end
  end
end