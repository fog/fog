module Fog
  module DNS
    class Zerigo
      class Real

        # Update the parameters of a zone
        # ==== Parameters
        #
        # * zone_id<~Integer>
        # * options<~Hash> - optional paramaters
        #   * default_ttl<~Integer>
        #   * ns_type<~String>
        #   * ns1<~String> - required if ns_type == sec
        #   * nx_ttl<~Integer> -
        #   * slave_nameservers<~String> - required if ns_type == pri
        #   * axfr_ips<~String> - comma-separated list of IPs or IP blocks allowed to perform AXFRs
        #   * custom_nameservers<~String> - comma-separated list of custom nameservers
        #   * custom_ns<~String> - indicates if vanity (custom) nameservers are enabled for this domain
        #   * hostmaster<~String> - email of the DNS administrator or hostmaster
        #   * notes<~String> - notes about the domain
        #   * restrict_axfr<~String> - indicates if AXFR transfers should be restricted to IPs in axfr-ips
        #   * tag_list<~String> - List of all tags associated with this domain
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * 'status'<~Integer> - 200 for success
        def update_zone(zone_id, options = {})

          optional_tags= ''
          options.each { |option, value|
            case option
            when :default_ttl
              optional_tags+= "<default-ttl>#{value}</default-ttl>"
            when :ns_type
              optional_tags+= "<ns-type>#{value}</ns-type>"
            when :ns1
              optional_tags+= "<ns1>#{value}</ns1>"
            when :nx_ttl
              optional_tags+= "<nx-ttl type='interger'>#{value}</nx-ttl>"
            when :slave_nameservers
              optional_tags+= "<slave-nameservers>#{value}</slave-nameservers>"
            when :axfr_ips
              optional_tags+= "<axfr-ips>#{value}</axfr-ips>"
            when :custom_nameservers
              optional_tags+= "<custom-nameservers>#{value}</custom-nameservers>"
            when :custom_ns
              optional_tags+= "<custom-ns>#{value}</custom-ns>"
            when :hostmaster
              optional_tags+= "<hostmaster>#{value}</hostmaster>"
            when :notes
              optional_tags+= "<notes>#{value}</notes>"
            when :restrict_axfr
              optional_tags+= "<restrict-axfr>#{value}</restrict-axfr>"
            when :tag_list
              optional_tags+= "<tag-list>#{value}</tag-list>"
            end
          }
          
          request(
            :body     => %Q{<?xml version="1.0" encoding="UTF-8"?><zone>#{optional_tags}</zone>},
            :expects  => 200,
            :method   => 'PUT',
            :path     => "/api/1.1/zones/#{zone_id}.xml"
          )
        end

      end

      class Mock # :nodoc:all
        def update_zone(zone_id, options = {})
          zone = find_by_zone_id(zone_id)

          response = Excon::Response.new

          if zone
            options.each { |k, v| zone[k.to_s] = v } # Deal with symbols in requests but strings in responses.
            zone['updated-at'] = Time.now

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
