require 'fog/core/model'

module Fog
  module HP
    class LB
      class VirtualIp

        identity :id
        attribute :address    ,
            "type" : "PUBLIC",
            "ipVersion" : "IPV4"

      end
    end
  end
end