require 'fog/core/model'

module Fog
  module Volume
    class SakuraCloud
      class Archive < Fog::Model

        identity :ID
        attribute :Name

      end
    end
  end
end
