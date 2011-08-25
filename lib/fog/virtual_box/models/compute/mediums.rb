require 'fog/core/collection'
require 'fog/virtual_box/models/compute/medium'

module Fog
  module Compute
    class VirtualBox

      class Mediums < Fog::Collection

        model Fog::Compute::VirtualBox::Medium

        def all
          data = []
          data.concat(connection.dvd_images)
          data.concat(connection.floppy_images)
          data.concat(connection.hard_disks)
          data = data.map do |medium|
            {:raw => medium}
          end
          load(data)
        end

        def get(medium_identity)
          data = connection.find_medium(medium_identity)
          new(:raw => data)
        end

      end

    end
  end
end
