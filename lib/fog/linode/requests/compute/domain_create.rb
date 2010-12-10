module Fog
  module Linode
    class Compute
      class Real

        # Creates a domain record
        #
        # ==== Parameters
        # * domain<~String>: The zone's name
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
        #   * body<~Array>:
        # TODO: docs
        def domain_create( domain, type, options)
          request(
            :expects  => 200,
            :method   => 'GET',
            :query    => {
              :api_action   => 'domain.create',
              :domain => domain,
              :type  => type
            }
          )
        end

      end

      class Mock

        def linode_create(datacenter_id, payment_term, plan_id)
          Fog::Mock.not_implemented
        end

      end
    end
  end
end
