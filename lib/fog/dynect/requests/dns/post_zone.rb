module Fog
  module DNS
    class Dynect
      class Real

        # Create a zone
        #
        # ==== Parameters
        # * rname<~String> - administrative contact
        # * ttl<~Integer> - time to live (in seconds) for records in this zone
        # * zone<~String> - name of zone to host
        # * options<~Hash>:
        #   * serial_style<~String> - style of serial number, in ['day', 'epoch', 'increment', 'minute']. Defaults to increment

        def post_zone(rname, ttl, zone, options = {})
          body = Fog::JSON.encode({
            :rname  => rname,
            :token  => auth_token,
            :ttl    => ttl
          }.merge!(options))

          request(
            :body     => body,
            :expects  => 200,
            :method   => :post,
            :path     => 'Zone/' << zone
          )
        end
      end

      class Mock
        def post_zone(rname, ttl, zone, options = {})
          new_zone = self.data[:zones][zone] = {
            :next_record_id => 0,
            :records => Hash.new do |records_hash, type|
              records_hash[type] = []
            end,
            :records_to_delete => [],
            :rname => rname,
            :serial_style => options[:serial_style] || "increment",
            :serial => 0,
            :ttl => ttl,
            :zone => zone,
            :zone_type => "Primary"
          }

          response = Excon::Response.new
          response.status = 200
          response.body = {
            "status" => "success",
            "data" => {
              "zone_type" => new_zone[:zone_type],
              "serial_style" => new_zone[:serial_style],
              "serial" => new_zone[:serial],
              "zone" => zone
            },
            "job_id" => Fog::Dynect::Mock.job_id,
            "msgs" => [{
              "INFO" => "create: New zone #{zone} created.  Publish it to put it on our server.",
              "SOURCE" => "BLL",
              "ERR_CD" => nil,
              "LVL" => "INFO"
            }]
          }

          response
        end
      end
    end
  end
end
