module Fog
  module DNS
    class Zerigo
      class Real

        require 'fog/zerigo/parsers/dns/create_host'

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
        #   * body<~Hash>
        #     * 'created-at'<~String>
        #     * 'data'<~String>
        #     * 'fqdn'<~String>
        #     * 'host-type'<~String>
        #     * 'hostname'<~String>
        #     * 'id'<~Integer>
        #     * 'notes'<~String>
        #     * 'priority'<~Integer>
        #     * 'ttl'<~Integer>
        #     * 'updated-at'<~String>
        #     * 'zone-id'<~String>
        #   * 'status'<~Integer> - 201 if successful        
        def create_host(zone_id, host_type, data, options = {})
          
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
            :expects  => 201,
            :method   => 'POST',
            :parser   => Fog::Parsers::DNS::Zerigo::CreateHost.new,
            :path     => "/api/1.1/zones/#{zone_id}/hosts.xml"
          )
        end

      end
    end
  end
end
