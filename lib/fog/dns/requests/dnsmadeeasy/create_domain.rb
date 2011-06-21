module Fog
  module DNS
    class DNSMadeEasy
      class Real

        # Creates a domain entry with the specified name. Returns errors if name is not valid or conflicts with another domain.
        #
        # ==== Parameters
        # * domain<~String> - domain name
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * name<~String> The domain name.
        #     * nameServer<~Array> List of strings, Name servers associated with this domain e.g. ["ns1.dnsmadeeasy.com", "ns2.dnsmadeeasy.com"]
        #     * gtdEnabled<~Boolean> true | false - Indicator of whether or not this domain uses the Global Traffic Director.
        #   * status<~Integer> - 201 - domain successfully created, 400 - domain name not valid, see errors in response content
        def create_domain(domain)
          request(
            :expects  => 201,
            :method   => 'PUT',
            :path     => "/V1.2/domains/#{domain}"
          )
        end

      end
    end
  end
end
