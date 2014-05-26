require 'fog/core/model'

module Fog
  module Compute
    class HPV2
      class Flavor < Fog::Model
        identity :id

        attribute   :name
        attribute   :disk
        attribute   :ram
        attribute   :cores, :aliases => 'vcpus'
        attribute   :ephemeral_disk, :aliases => 'OS-FLV-EXT-DATA:ephemeral'
        attribute   :links
      end
    end
  end
end
