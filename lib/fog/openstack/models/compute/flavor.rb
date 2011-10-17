require 'fog/core/model'

module Fog
  module Compute
    class OpenStack

      class Flavor < Fog::Model

        identity :id

        attribute :disk
        attribute :name
        attribute :ram
        attribute :links

      end

    end
  end
end
