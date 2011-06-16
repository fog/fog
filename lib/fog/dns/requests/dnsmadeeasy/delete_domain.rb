module Fog
  module DNS
    class DNSMadeEasy
      class Real

        # Delete the given domain from your account.
        #
        # ==== Parameters
        # * domain<~String> - domain name
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * status<~Integer> 200 - OK, 404 - specified domain name is not found
        def delete_domain(domain)
          request(
            :expects  => 200,
            :method   => 'DELETE',
            :path     => "/V1.2/domains/#{domain}"
          )
        end

      end
    end
  end
end
