require 'fog/core/model'

module Fog
  module Compute
    class RackspaceV2
      class Flavor < Fog::Model
        # @!attribute [r] id
        # @return [String] The flavor id
        identity :id

        # @!attribute [r] name
        # @return [String] flavor name
        attribute :name

        # @!attribute [r] rame
        # @return [Fixnum] ram in MB
        attribute :ram

        # @!attribute [r] disk
        # @return [String] disk space in GB
        attribute :disk

        # @!attribute [r] vcpus
        # @return [Fixnum] number of virtual CPUs
        attribute :vcpus

        # @!attribute [r] links
        # @return [Array] flavor links.
        attribute :links
      end
    end
  end
end
