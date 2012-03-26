module Fog
  module Compute
    class Joyent
      class Flavor < Fog::Model

        identity :name

        attribute :name
        attribute :memory
        attribute :swap
        attribute :disk
        attribute :default

      end
    end
  end
end
