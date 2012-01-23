module Fog
  module DNS
    class Zerigo
      class Real

        # Update a host record
        #
        # ==== Parameters
        # * host_id<~Integer> - host ID of the record to update
        # * options<~Hash> - optional paramaters
        #   * host_type<~String>
        #   * data<~String>
        #   * hostname<~String> - Note: normally this is set/required!!
        #   * notes<~String>
        #   * priority<~Integer> - Note: required for MX or SRV records
        #   * ttl<~Integer>
        # ==== Returns
        # * response<~Excon::Response>: 
        #   * 'status'<~Integer> - 200 for success
        #
        def update_host(host_id, options = {})

          optional_tags= ''
          options.each { |option, value|
            case option
            when :host_type
              optional_tags+= "<host-type>#{value}</host-type>"
            when :data
              optional_tags+= "<data>#{value}</data>"
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
            :body     => %Q{<?xml version="1.0" encoding="UTF-8"?><host>#{optional_tags}</host>},
            :expects  => 200,
            :method   => 'PUT',
            :path     => "/api/1.1/hosts/#{host_id}.xml"
          )
        end

      end

      class Mock # :nodoc:all
        def update_host(host_id, options = {})
          host = find_host(host_id)

          response = Excon::Response.new

          if host
            options.each { |k, v| host[k.to_s] = v } # Deal with symbols in requests but strings in responses.
            host['updated-at'] = Time.now

            response.status = 200
          else
            response.status = 404
          end

          response
        end
      end
    end
  end
end
