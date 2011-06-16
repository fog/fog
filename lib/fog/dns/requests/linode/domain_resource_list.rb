module Fog
  module DNS
    class Linode
      class Real

        # List of resource records for a domain
        #
        # ==== Parameters
        # * domain_id<~Integer>: limit the list to the domain ID specified
        # * resource_id<~Integer>: optional.  use if want only a specific resource record
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Array>:
        #     * DATA<~Array>
        #       * 'PROTOCOL'<~String>:  for SRV records. default is UDP 
        #       * 'TTL_SEC'<~Interger>: 
        #       * 'PRIORITY'<~Interger>: for MX and SRV records
        #       * 'TYPE'<~String>: One of: NS, MX, A, AAAA, CNAME, TXT, or SRV 
        #       * 'TARGET'<~String>: When Type=MX the hostname. When Type=CNAME the target of the alias. 
        #                           When Type=TXT the value of the record. When Type=A or AAAA the token 
        #                           of '[remote_addr]' will be substituted with the IP address of the request.
        #       * 'WEIGHT'<~Interger>: 
        #       * 'RESOURCEID'<~Interger>: ID of the resource record
        #       * 'PORT'<~Interger>: 
        #       * 'DOMAINID'<~Interger>: ID of the domain that this record belongs to
        #       * 'NAME'<~Interger>: The hostname or FQDN. When Type=MX, the subdomain to delegate to        
        def domain_resource_list(domain_id, resource_id = nil)
          query = { :api_action => 'domain.resource.list', :domainID => domain_id }
          if resource_id
            query[:resourceID] = resource_id
          end
          request(
            :expects  => 200,
            :method   => 'GET',
            :query    => query
          )
        end

      end
    end
  end
end
