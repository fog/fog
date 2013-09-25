require 'fog/core/collection'
require 'fog/cloudstack/models/compute/disk_offering'

module Fog
  module Compute
    class Cloudstack

      class DiskOfferings < Fog::Collection

        model Fog::Compute::Cloudstack::DiskOffering

        def all
          data = connection.list_disk_offerings["listdiskofferingsresponse"]["diskoffering"] || []
          load(data)
        end

        def all(options = {})
          response = service.list_disk_offerings(options)
          disk_offerings_data = response["listdiskofferingsresponse"]["diskoffering"] || []
        end

        def get(disk_offering_id)
          response = service.list_disk_offerings('id' => disk_offering_id)
          disk_offering_data = response["listdiskofferingsresponse"]["diskoffering"].first
          new(disk_offering_data)
        end
      end

    end
  end
end
