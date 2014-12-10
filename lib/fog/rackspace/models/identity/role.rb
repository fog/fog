require 'fog/core/model'

module Fog
  module Rackspace
    class Identity
      class Role < Fog::Model
        identity :id

        attribute :name
        attribute :description
      end
    end
  end
end
