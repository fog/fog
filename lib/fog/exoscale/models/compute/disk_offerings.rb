require 'fog/core/collection'
require 'fog/exoscale/models/compute/disk_offering'

module Fog
  module Compute
    class Exoscale
      class DiskOfferings < Fog::Collection
        model Fog::Compute::Exoscale::DiskOffering

        def all(options = {})
          raise Fog::Errors::Error.new('Listing disk offerings is not supported')
        end

        def get(disk_offering_id)
          raise Fog::Errors::Error.new('Retrieving a disk offering is not supported')
        end
      end
    end
  end
end
