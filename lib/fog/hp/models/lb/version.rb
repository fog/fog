require 'fog/core/model'

module Fog
  module HP
    class LB
      class Version < Fog::Model
        identity :id
        attribute :status
        attribute :updated
      end
    end
  end
end
