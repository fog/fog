module Fog
  module Zerigo
    class Compute
      class Real

        require 'fog/zerigo/parsers/compute/create_host'

        # Create a new host in the specified zone
        #
        # ==== Parameters
        # * zone_id<~Integer>
        # * host_type<~String>
        # * data<~String>
        # * options<~Hash> - optional paramaters
        #   * hostname<~String> - Note: normally this is set/required!!
        #   * notes<~String>
        #   * priority<~Integer> - Note: required for MX or SRV records
        #   * ttl<~Integer>
        # ==== Returns
        # * response<~Excon::Response>: 
        #   * 'created-at'<~String>
        #   * 'data'<~String>
        #   * 'fqdn'<~String>
        #   * 'host-type'<~String>
        #   * 'hostname'<~String>
        #   * 'id'<~Integer>
        #   * 'notes'<~String>
        #   * 'priority'<~Integer>
        #   * 'ttl'<~Integer>
        #   * 'updated-at'<~String>
        #   * 'zone-id'<~String>
        def create_host( zone_id, host_type, data, options = {} )
          
          optional_tags= ''
          options.each { |option, value|
            case option
            when :hostname
              optional_tags+= "<hostname>#{value}</hostname>"
            when :notes
              optional_tags+= "<notes>#{value}</notes>"
            when :priority
              optional_tags+= "<priority>#{value}</priority>"
            when :ttl
              optional_tags+= "<ttl>#{value}</ttl>"
            end
          }
            
          request(
            :body     => %Q{<?xml version="1.0" encoding="UTF-8"?><host><host-type>#{host_type}</host-type><data>#{data}</data>#{optional_tags}</host>},
            :expects  => 200,
            :method   => 'POST',
            :parser   => Fog::Parsers::Zerigo::Compute::CreateHost.new,
            :path     => "/api/1.1/zones/#{zone_id}/hosts.xml"
          )
        end

      end

      class Mock

        def create_host( zone_id, host_type, data, options = {})
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
