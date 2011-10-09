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
        # * options<~Hash> - optional parameters
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

      class Mock # :nodoc:all
        def valid_host_types
          %w[A AAAA CNAME GEO MX NS SPF SRV TXT URL PTR CNAME NS]
        end

        def create_host(zone_id, host_type, data, options = {})
          zone = find_by_zone_id(zone_id)

          response = Excon::Response.new

          # Handle error cases.

          # Zone doesn't exist.
          unless zone
            response.status = 404
            return response
          end

          # Bad host type.
          unless valid_host_types.include?(host_type)
            response.status = 422
            response.body = {
              'errors' => [
                'error' => 'Host type is not included in the list'
              ]
            }

            return response
          end

          # Missing or bad priority value for MX or SRV records.
          if %w[MX SRV].include?(host_type) && options['priority'].to_s !~ /\d+/
            response.status = 422
            response.body = {
              'errors' => [
                'error' => 'Priority is not a number'
              ]
            }

            return response
          end

          # Successful case.
          now = Time.now
          host = {
            'id'            => rand(10000000),
            'fqdn'          => options[:hostname] ? "#{options[:hostname]}.#{zone['domain']}" : zone['domain'],
            'data'          => data,
            'hostname'      => options[:hostname],
            'ttl'           => options[:ttl].to_i,
            'host-type'     => host_type,
            'created-at'    => now,
            'updated-at'    => now,
            'notes'         => options[:notes],
            'priority'      => options[:priority].to_i,
            'zone-id'       => zone_id
          }

          zone['hosts'] << host
          response.status = 201
          response.body = host

          response
        end
      end
    end
  end
end
