module Fog
  module DNS
    class DNSMadeEasy
      class Real
        # Returns a record object representing the record with the specified id.
        #
        # ==== Parameters
        # * domain<~String>
        # * record_id<~Integer>
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * id<~Integer> Unique record identifier
        #     * name<~String> Record name.
        #     * type<~String> Record type. Values: A, AAAA, CNAME, HTTPRED, MX, NS, PTR, SRV, TXT
        #     * data<~String> Record data
        #     * ttl<~Integer> Time to live. The amount of time a record will be cached before being refreshed. Default: 1800
        #     * gtdLocation<~String> Global Traffic Director location. Values: DEFAULT, US_EAST, US_WEST, EUROPE
        #     * password<~String> For A records. Password used to authenticate for dynamic DNS.
        #     * description<~String> For HTTPRED records. A description of the HTTPRED record.
        #     * keywords<~String> For HTTPRED records. Keywords associated with the HTTPRED record.
        #     * title<~String> For HTTPRED records. The title of the HTTPRED record.
        #     * redirectType<~String> For HTTPRED records. Type of redirection performed. Values: Hidden Frame Masked, Standard - 302, Standard - 301
        #     * hardLink<~Boolean> For HTTPRED records.
        #   * status<~Integer> - 200 - OK, 404 - specified domain name or record id is not found
        def get_record(domain, record_id)
          request(
            :expects  => 200,
            :method   => "GET",
            :path     => "/V1.2/domains/#{domain}/records/#{record_id}"
          )
        end
      end
    end
  end
end
