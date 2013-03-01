require 'fog/core/model'

module Fog
  module HP
    class LB
      class Node

        identity :id
        attribute :address
        attribute :port
        attribute :condition
        attribute :status

      end

    end
  end
end