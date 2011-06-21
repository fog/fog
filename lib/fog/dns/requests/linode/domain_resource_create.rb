module Fog
  module DNS
    class Linode
      class Real

        # Creates a resource record in a domain
        #
        # ==== Parameters
        # * domain_id<~Integer>: limit the list to the domain ID specified
        # * type<~String>: One of: NS, MX, A, AAAA, CNAME, TXT, or SRV 
        # * options<~Hash>
        #   * name<~String>: The hostname or FQDN. When Type=MX the subdomain to delegate to the 
        #                    Target MX server
        #   * target<~String> When Type=MX the hostname. When Type=CNAME the target of the alias.
        #                    When Type=TXT the value of the record. When Type=A or AAAA the token 
        #                    of '[remote_addr]' will be substituted with the IP address of the request. 
        #   * priority<~Integer>: priority for MX and SRV records, 0-255 - default: 10 
        #   * weight<~Integer>: default: 5
        #   * port<~Integer>: default: 80 
        #   * protocol<~String>: The protocol to append to an SRV record. Ignored on other record 
        #                        types. default: udp 
        #   * ttl_sec<~Integer>: note, Linode will round the input to set values (300, 3600, 7200, etc)
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * DATA<~Hash>:
        #       * 'ResourceID'<~Integer>: ID of the resource record created
        def domain_resource_create(domain_id, type, options = {})
          query= {}
          request(
            :expects  => 200,
            :method   => 'GET',
            :query    => {
              :api_action   => 'domain.resource.create',
              :domainID => domain_id,
              :type  => type
            }.merge!( options)
          )
        end

      end
    end
  end
end
