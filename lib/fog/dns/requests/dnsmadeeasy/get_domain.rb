module Fog
  module DNS
    class DNSMadeEasy
      class Real

        # Get the details for a specific domain in your account.
        #
        # ==== Parameters
        # * domain<~String> - domain name
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * name<~String> The domain name.
        #     * nameServer<~Array> List of strings, Name servers associated with this domain e.g. ["ns1.dnsmadeeasy.com", "ns2.dnsmadeeasy.com"]
        #     * gtdEnabled<~Boolean> Indicator of whether or not this domain uses the Global Traffic Director.
        #   * status<~Integer> 200 - OK, 404 - specified domain name is not found
        def get_domain(domain)
          request(
            :expects  => 200,
            :method   => "GET",
            :path     => "/V1.2/domains/#{domain}"
          )
        end

      end
    end
  end
end
