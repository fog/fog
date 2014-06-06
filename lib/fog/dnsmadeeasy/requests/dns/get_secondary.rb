module Fog
  module DNS
    class DNSMadeEasy
      class Real
        # Returns the secondary entry object representation of the specified secondary entry.
        #
        # ==== Parameters
        # * secondary_name<~String> - secondary name
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * name<~String> Secondary name.
        #     * ip<~Array> List of strings, IP addresses for your master nameserver associated with this secondary entry. e.g. ["10.10.10.10", "10.10.10.11"]
        #     * gtdLocation<~String> Global Traffic Director location. Values: DEFAULT, US_EAST, US_WEST, EUROPE
        #   * status<~Integer> - 200 - OK, 404 - specified secondary entry name is not found
        def get_secondary(secondary_name)
          request(
            :expects  => 200,
            :method   => "GET",
            :path     => "/V1.2/secondary/#{secondary_name}"
          )
        end
      end
    end
  end
end
