require 'fog/core/model'

module Fog
  module HP
    class LB
      class VirtualIp < Fog::Model
        identity :id

        attribute :address
        attribute :ip_version, :alias => "ipVersion"
        attribute :type
        attribute :load_balancer_id
      end
    end
  end
end
