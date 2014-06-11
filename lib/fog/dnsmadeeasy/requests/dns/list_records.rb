module Fog
  module DNS
    class DNSMadeEasy
      class Real
        # Returns a list of record objects containing all records for the specified domain
        #
        # ==== Parameters
        # * domain<~String>
        # * options<~Hash>
        #   * gtdLocation<~String> Global Traffic Director location. Values: DEFAULT, US_EAST, US_WEST, EUROPE
        #   * type<~String> Record type. Values: A, AAAA, CNAME, HTTPRED, MX, NS, PTR, SRV, TXT
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * id<~Integer> Unique record identifier
        #     * name<~String> Record name.
        #     * type<~String> Record type. Values: A, AAAA, CNAME, HTTPRED, MX, NS, PTR, SRV, TXT
        #     * data<~String>
        #     * ttl<~Integer> Time to live. The amount of time a record will be cached before being refreshed.
        #     * gtdLocation<~String> Global Traffic Director location. Values: DEFAULT, US_EAST, US_WEST, EUROPE
        #     * password<~String> For A records. Password used to authenticate for dynamic DNS.
        #     * description<~String> For HTTPRED records. A description of the HTTPRED record.
        #     * keywords<~String> For HTTPRED records. Keywords associated with the HTTPRED record.
        #     * title<~String> For HTTPRED records. The title of the HTTPRED record.
        #     * redirectType<~String> For HTTPRED records. Type of redirection performed. Values: Hidden Frame Masked, Standard - 302, Standard - 301
        #     * hardLink<~Boolean> For HTTPRED records.
        #   * status<~Integer> - 200 - OK, 404 - specified domain name is not found
        def list_records(domain, options = {})
          request(
            :expects  => 200,
            :method   => "GET",
            :path     => "/V1.2/domains/#{domain}/records",
            :query    => options
          )
        end
      end
    end
  end
end
