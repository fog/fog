require 'fog/core/model'

module Fog
  module Rackspace
    class BlockStorage
      class VolumeType < Fog::Model
        identity :id

        attribute :name
        attribute :extra_specs
      end
    end
  end
end
