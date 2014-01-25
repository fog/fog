require 'fog/core/model'

module Fog
  module Compute
    class SakuraCloud
      class Zone < Fog::Model

        identity :ID
        attribute :Name
        attribute :Description

      end
    end
  end
end
