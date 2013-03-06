require 'fog/core/model'

module Fog
  module HP
    class LB
      class Node < Fog::Model

        identity :id
        attribute :address
        attribute :port
        attribute :condition
        attribute :status

      end

    end
  end
end