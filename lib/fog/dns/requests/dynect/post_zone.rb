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
          body = MultiJson.encode({
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
    end
  end
end
