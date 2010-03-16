require 'fog/model'

module Fog
  module AWS
    module EC2

      class Flavor < Fog::Model

        identity :id

        attribute :bits
        attribute :cores
        attribute :disk
        attribute :name
        attribute :ram

      end

    end
  end
end