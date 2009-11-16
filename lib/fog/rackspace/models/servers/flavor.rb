module Fog
  module Rackspace
    class Servers

      class Flavor < Fog::Model

        identity :id

        attribute :disk
        attribute :id
        attribute :name
        attribute :ram

      end

    end
  end
end
