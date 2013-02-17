require 'fog/core/model'

module Fog
  module Bluebox
    class BLB

      class Application < Fog::Model
        identity :id
        
        attribute :name
        attribute :ip_v4
        attribute :ip_v6
        attribute :services
        attribute :description
        attribute :created,     :aliases => 'created_at'

      end

    end
  end
end
