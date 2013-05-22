require 'fog/core/model'

module Fog
  module HP
    class LB
      class Version < Fog::Model
        identity :id
        attribute :status
        attribute :updated_at, :alias => "updated"
      end
    end
  end
end
