require 'fog/core/model'

module Fog
  module Compute
    class Google
      ##
      # Represents a Region resource
      #
      # @see https://developers.google.com/compute/docs/reference/latest/regions
      class Region < Fog::Model
        identity :name

        attribute :kind
        attribute :id
        attribute :creation_timestamp, :aliases => 'creationTimestamp'
        attribute :deprecated
        attribute :description
        attribute :quotas
        attribute :self_link, :aliases => 'selfLink'
        attribute :status
        attribute :zones

        DOWN_STATE = 'DOWN'
        UP_STATE   = 'UP'

        def up?
          self.status == UP_STATE
        end
      end
    end
  end
end
