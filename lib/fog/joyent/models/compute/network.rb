module Fog
  module Compute
    class Joyent
      class Network < Fog::Model
        identity :id

        attribute :name

      end
    end
  end
end
