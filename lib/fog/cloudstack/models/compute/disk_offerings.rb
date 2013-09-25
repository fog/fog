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

      end

    end
  end
end
