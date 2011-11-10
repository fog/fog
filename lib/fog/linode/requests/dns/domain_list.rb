module Fog
  module DNS
    class Linode
      class Real

        # List of domains (you have access to)
        #
        # ==== Parameters
        # * domain_id<~Integer>: limit the list to the domain ID specified
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Array>:
        #     * DATA<~Array>
        #       * 'DOMAINID'<~Interger>
        #       * 'SOA_EMAIL'<~String>
        #       * 'DESCRIPTION'<~String>
        #       * 'TTL_SEC'<~String>
        #       * 'EXPIRE_SEC'<~Integer>
        #       * 'RETRY_SEC'<~Integer>
        #       * 'DOMAIN'<~String>
        #       * 'STATUS'<~Integer>
        #       * 'MASTER_IPS'<~String>
        #       * 'REFRESH_SEC'<~Integer>
        #       * 'TYPE'<~String>
        def domain_list(domain_id = nil)
          options = {}
          if domain_id
            options.merge!(:domainId => domain_id)
          end

          request(
            :expects  => 200,
            :method   => 'GET',
            :query    => { :api_action => 'domain.list' }.merge!(options)
          )
        end

      end
    end
  end
end
