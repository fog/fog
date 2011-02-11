module Fog
  module Linode
    class DNS
      class Real

        # Creates a domain record
        #
        # ==== Parameters
        # * domain<~String>: The zone's name.  Note, if master zone, SOA_email is required and if slave
        #                    master_ips is/are required
        # * type<~String>: master or slave 
        # * options<~Hash>
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
        def domain_create(domain, type, options = {})
          query= {}
          request(
            :expects  => 200,
            :method   => 'GET',
            :query    => {
              :api_action   => 'domain.create',
              :domain => domain,
              :type  => type
            }.merge!( options)
          )
        end

      end
    end
  end
end
