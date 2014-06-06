module Fog
  module DNS
    class DNSMadeEasy
      class Real
        # Returns a list of all domain names for your account.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * list<~Array> e.g. ["domain1.com","domain2.com", "domain3.com"]
        #   * status<~Integer> - 200 - OK
        def list_domains
          request(
            :expects  => 200,
            :method   => 'GET',
            :path     => '/V1.2/domains'
          )
        end
      end
    end
  end
end
