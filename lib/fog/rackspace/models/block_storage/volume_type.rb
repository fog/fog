require 'fog/core/model'

module Fog
  module Rackspace
    class BlockStorage
      class VolumeType < Fog::Model
        # @!attribute [r] id
        # @return [String] The volume type id
        identity :id

        # @!attribute [r] name
        # @return [String] The name of the volume type
        attribute :name

        attribute :extra_specs
      end
    end
  end
end
