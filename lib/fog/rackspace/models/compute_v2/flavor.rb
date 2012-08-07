require 'fog/core/model'

module Fog
  module Compute
    class RackspaceV2
      class Flavor < Fog::Model
        identity :id

        attribute :name
        attribute :ram
        attribute :disk
        attribute :vcpus
        attribute :links
      end
    end
  end
end
