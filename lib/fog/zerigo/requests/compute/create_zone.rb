module Fog
  module Zerigo
    class Compute
      class Real

        require 'fog/zerigo/parsers/compute/create_zone'

        # Create a new zone for Slicehost's DNS servers to serve/host
        # ==== Parameters
        #
        # * domain<~String>
        # * default_ttl<~Integer>
        # * ns_type<~String>
        # * options<~Hash> - optional paramaters
        #   * ns1<~String> - required if ns_type == sec
        #   * nx_ttl<~Integer> -
        #   * slave_nameservers<~String> - required if ns_type == pri
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'origin'<~String> - as above
        #     * 'id'<~Integer> - Id of zone/domain - used in future API calls
        #     * 'ttl'<~Integer> - as above
        #     * 'active'<~String> - as above
        def create_zone( domain, default_ttl, ns_type, options = {})

          optional_tags= ''
          options.each { |option, value|
            case option
            when :ns1
              optional_tags+= "<ns1>#{value}</ns1>"
            when :nx_ttl
              optional_tags+= "<nx-ttl type='interger'>#{value}</nx-ttl>"
            when :slave_nameservers
              optional_tags+= "<slave-nameservers>#{value}</slave-nameservers>"
            end
          }
          
          request(
            :body     => %Q{<?xml version="1.0" encoding="UTF-8"?><zone><domain>#{domain}</domain><default-ttl type="integer">#{default_ttl}</default-ttl><ns-type>#{ns_type}</ns-type>#{optional_tags}</zone>},
            :expects  => 201,
            :method   => 'POST',
            :parser   => Fog::Parsers::Slicehost::Compute::CreateZone.new,
            :path     => '/api/1.1/zones.xml'
          )
        end

      end

      class Mock

        def create_zone(domain, default_ttl, ns_type, options = {})
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
