module Fog
  module DNS
    class Linode
      class Real

        # Update a domain record
        #
        # ==== Parameters
        # * domain_id<~Integer>: The ID to identify the zone
        # * options<~Hash>
        #   * domain<~String>: The zone's name.  
        #   * type<~String>: master or slave 
        #   * description<~String> Currently undisplayed
        #   * SOA_email<~String> Required when type=master
        #   * refresh_sec<~Integer> numeric, default: '0'
        #   * retry_sec<~Integer> numeric, default: '0'
        #   * expire_sec<~Integer> numeric, default: '0'
        #   * ttl_sec<~String> numeric, default: '0'
        #   * status<~Integer> 0, 1, or 2 (disabled, active, edit mode), default: 1 
        #   * master_ips<~String> When type=slave, the zone's master DNS servers list, semicolon separated 
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * DATA<~Hash>:
        #       * 'DomainID'<~Integer>: domain ID
        def domain_update(domain_id, options = {})
          
          request(
            :expects  => 200,
            :method   => 'GET',
            :query    => { :api_action => 'domain.update', :domainId => domain_id }.merge!(options)
          )

        end

      end
    end
  end
end
