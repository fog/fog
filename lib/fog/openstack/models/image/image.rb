require 'fog/core/model'

module Fog
  module Image
    class OpenStack

      class Image < Fog::Model

        identity :id

        attribute :name
        attribute :size
        attribute :disk_format
        attribute :container_format
        attribute :id
        attribute :checksum

      end

    end
  end
end
