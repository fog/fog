module Fog
  module AWS
    class EC2

      class Flavor < Fog::Model

        identity :id

        attribute :bits
        attribute :cores
        attribute :disk
        attribute :id
        attribute :name
        attribute :ram

      end

    end
  end
end