module Fog
  module DNS
    class Rage4
      class Real
        # Updates an existing record
        # ==== Parameters
        # * record_id <~Integer> The id of the record you wish to update
        # * name <~String> Name of record, include domain name
        # * content <~String> IP address or Domain name
        # * type <~Integer> The type of record to create see list_record_types
        # * priority <~Integer> - Record prioirity (nullable)
        # * failover <~Boolean> Enable/disable failover default false
        # * failovercontent <~String> Failover value, only valid for A/AAAA records
        # * ttl <~Integer> - Time to live
        # * geozone <~Long> Geo region id, see list_geo_regions
        # * geolock <~Boolean> Lock geo coordinates, default false
        # * geolat <~Double> Geo latitude, (nullable)
        # * geolong <~Double> Geo longitude, (nullable)
        # * udplimit <~Boolean> Limit number of records returned, (nullable, default false)
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #      * 'status'<~Boolean>
        #      * 'id'<~Integer>
        #      * 'error'<~String>

# https://secure.rage4.com//rapi/SetRecordState/<zone_id>/

        def bulk_update_records(zone_id, options = {})
          path = "/rapi/SetRecordState/#{zone_id}"
          body = options[:body] if options[:body].present?

          request(
                  :expects  => 200,
                  :method   => 'POST',
                  :body     => body,
                  :path     => path
          )
        end
      end
    end
  end
end
