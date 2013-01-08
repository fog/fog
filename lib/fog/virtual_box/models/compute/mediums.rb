require 'fog/core/collection'
require 'fog/virtual_box/models/compute/medium'

module Fog
  module Compute
    class VirtualBox

      class Mediums < Fog::Collection

        model Fog::Compute::VirtualBox::Medium

        def all
          data = []
          data.concat(service.dvd_images)
          data.concat(service.floppy_images)
          data.concat(service.hard_disks)
          data = data.map do |medium|
            {:raw => medium}
          end
          load(data)
        end

        def get(medium_identity)
          data = service.find_medium(medium_identity)
          new(:raw => data)
        end

      end

    end
  end
end
