module Fog
  module DNS
    class Slicehost
      class Real

        require 'fog/slicehost/parsers/dns/create_zone'

        # Create a new zone for Slicehost's DNS servers to serve/host
        # ==== Parameters
        # * origin<~String> - domain name to host (ie example.com)
        # * options<~Hash> - optional paramaters
        #   * ttl<~Integer> - TimeToLive (ttl) for the domain, in seconds (> 60)
        #   * active<~String> - whether zone is active in Slicehost DNS server - 'Y' or 'N'
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'origin'<~String> - as above
        #     * 'id'<~Integer> - Id of zone/domain - used in future API calls
        #     * 'ttl'<~Integer> - as above
        #     * 'active'<~String> - as above
        def create_zone(origin, options = {})

          optional_tags= ''
          options.each { |option, value|
            case option
            when :ttl
              optional_tags+= "<ttl type='interger'>#{value}</ttl>"
            when :active
              optional_tags+= "<active>#{value}</active>"
            end
          }
          
          request(
            :body     => %Q{<?xml version="1.0" encoding="UTF-8"?><zone><origin>#{origin}</origin>#{optional_tags}</zone>},
            :expects  => 201,
            :method   => 'POST',
            :parser   => Fog::Parsers::DNS::Slicehost::CreateZone.new,
            :path     => 'zones.xml'
          )
        end

      end
    end
  end
end
