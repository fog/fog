require 'fog/core/model'

module Fog
  module Compute
    class AWS

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
