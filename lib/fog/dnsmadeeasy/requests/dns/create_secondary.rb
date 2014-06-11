module Fog
  module DNS
    class DNSMadeEasy
      class Real
        # Creates a secondary entry with the specified name. Returns errors if name is not valid or conflicts with another domain.
        #
        # ==== Parameters
        # * secondary_name<~String> - secondary name
        # * ip_addresses<~Array> - List of secondary ip addresses
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * name<~String> Secondary name.
        #     * ip<~Array> List of strings, IP addresses for your master nameserver associated with this secondary entry. e.g. ["10.10.10.10", "10.10.10.11"]
        #     * gtdLocation<~String> Global Traffic Director location. Values: DEFAULT, US_EAST, US_WEST, EUROPE
        #   * status<~Integer> - 201 - secondary entry successfully created or modified, 400 - secondary entry name or IP addresses not valid, see errors in response content
        def create_secondary(secondary_name, ip_addresses)
          body = {
            "ip" => [*ip_addresses]
          }

          request(
            :expects  => 201,
            :method   => 'PUT',
            :path     => "/V1.2/secondary/#{secondary_name}",
            :body     => Fog::JSON.encode(body)
          )
        end
      end
    end
  end
end
