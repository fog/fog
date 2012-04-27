require 'fog/core/collection'
require 'fog/serverlove/models/compute/drive'

module Fog
  module Compute
    class Serverlove

      class Drives < Fog::Collection

        model Fog::Compute::Serverlove::Drive

        def all
          data = connection.get_drives.body
          load(data)
        end

        def get(drive_id)
          connection.get_drive(drive_id)
        end

      end

    end
  end
end
