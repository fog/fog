module Fog
  module Compute
    class Joyent
      class Datacenter < Fog::Model
        identity :name

        attribute :url
      end
    end
  end
end
