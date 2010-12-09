module Fog
  module Slicehost
    class Compute
      class Real

        require 'fog/slicehost/parsers/compute/create_zone'

        # Create a new zone for Slicehost's DNS servers to serve/host
        # ==== Parameters
        # * origin<~String> - domain name to host (ie example.com)
        # * ttl<~Integer> - TimeToLive (ttl) for the domain, in seconds (> 60)
        # * active<~String> - whether zone is active in Slicehost DNS server - 'Y' or 'N'
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Array>:
        #     * 'origin'<~String> - domain added 
        #     * 'id'<~Integer> - Id of zone/domain
        #     * 'ttl'<~Integer> - TimeToLive for zone (how long client can cache)
        #     * 'active'<~String> - whether zone is active or disabled
        def create_zone(origin, ttl, active)
          request(
            :body     => %Q{<?xml version="1.0" encoding="UTF-8"?><zone><origin>#{origin}</origin><ttl type="integer">#{ttl}</ttl><active>#{active}</active></zone>},
            :expects  => 201,
            :method   => 'POST',
            :parser   => Fog::Parsers::Slicehost::Compute::CreateZone.new,
            :path     => 'zones.xml'
          )
        end

      end

      class Mock

        def create_zone(origin, ttl, active)
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
