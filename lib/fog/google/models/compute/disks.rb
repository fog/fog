require 'fog/core/collection'
require 'fog/google/models/compute/disk'

module Fog
  module Compute
    class Google

      class Disks < Fog::Collection

        model Fog::Compute::Google::Disk

        def all(filters={})
          if filters['zone'].nil?
            data = []
            service.list_zones.body['items'].each do |zone|
              data += service.list_disks(zone['name']).body["items"] || []
            end
          else
            data = service.list_disks(filters['zone']).body["items"] || []
          end
          load(data)
        end

        def get(identity, zone=nil)
          response = nil
          if zone.nil?
            service.list_zones.body['items'].each do |zone|
              begin
                response = service.get_disk(identity, zone['name'])
                break if response.status == 200
              rescue Fog::Errors::Error
              end
            end
          else
            response = service.get_disk(identity, zone)
          end
          return nil if response.nil?
          new(response.body)
        end

      end

    end
  end
end
