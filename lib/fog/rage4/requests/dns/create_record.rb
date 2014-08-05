module Fog
  module DNS
    class Rage4
      class Real
        # Create a record
        # ==== Parameters
        # * domain id <~Integer> The id of the domain you wish to create a record for
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

# https://secure.rage4.com/rapi/createrecord/

        def create_record(domain_id, name, content, type, options = {})
          path = "/rapi/createrecord/#{domain_id}"
          path << "?name=#{name}&content=#{content}&type=#{type}"

          path << "&priority=#{options[:priority]}" if options[:priority]

          failover = options[:failover] || 'false'
          path << "&failover=#{failover}"

          path << "&failovercontent=#{options[:failovercontent]}" if options[:failovercontent]

          ttl = options[:ttl] || 3600
          path << "&ttl=#{ttl}"

          path << "&geozone=#{options[:geozone]}" if options[:geozone]
          path << "&geolock=#{options[:geolock]}" if options[:geolock]
          path << "&geolat=#{options[:geolat]}"   if options[:geolat]
          path << "&geolong=#{options[:geolong]}" if options[:geolong]
          path << "&udplimit=#{options[:udplimit]}" if options[:udplimit]

          request(
                  :expects  => 200,
                  :method   => 'GET',
                  :path     => path
          )
        end
      end
    end
  end
end
