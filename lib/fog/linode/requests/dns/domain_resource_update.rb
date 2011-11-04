module Fog
  module DNS
    class Linode
      class Real

        # Updates a resource record in a domain
        #
        # ==== Parameters
        # * domain_id<~Integer>: limit the list to the domain ID specified
        # * resource_id<~Integer>: id of resouce to delete
        # * options<~Hash>
        #   * type<~String>: One of: NS, MX, A, AAAA, CNAME, TXT, or SRV
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
        #       * 'ResourceID'<~Integer>: ID of the resource record updated
        def domain_resource_update(domain_id, resource_id, options = {})

          query= {}
          request(
            :expects  => 200,
            :method   => 'GET',
            :query    => {
              :api_action   => 'domain.resource.update',
              :domainID => domain_id,
              :resourceID => resource_id,
            }.merge!( options)
          )
        end

      end
    end
  end
end
