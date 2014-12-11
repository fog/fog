require 'fog/core/model'

module Fog
  module Rackspace
    class Identity
      class Tenant < Fog::Model
        identity :id

        attribute :name
        attribute :description
        attribute :enabled
      end
    end
  end
end
