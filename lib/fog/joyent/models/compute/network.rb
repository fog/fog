module Fog
  module Compute
    class Joyent
      class Network < Fog::Model
        identity :id

        attribute :name
        attribute :public
      end
    end
  end
end
