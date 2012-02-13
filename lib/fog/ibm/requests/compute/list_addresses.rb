module Fog
  module Compute
    class IBM
      class Real

        # Returns the list of static IP addresses for current user
        #
        # ==== Parameters
        # No parameters
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'addresses'<~Array>: list of addresses
        #       * 'location'<~String>: location of address
        #       * 'mode'<~Integer>:
        #       * 'offeringId'<~String>: offering ID
        #       * 'id'<~String>: id
        #       * 'type'<~Integer>: TODO unsure
        #       * 'ip'<~String>: IP address.. with space at the end
        #       * 'hostname'<~String>: seems to be same as ip
        #       * 'state'<~Integer>: state of address
        def list_addresses
          request(
            :method   => 'GET',
            :expects  => 200,
            :path     => '/addresses'
          )
        end

      end
      class Mock

        def list_addresses
          response = Excon::Response.new
          response.status = 200
          response.body = {'addresses' => self.data[:addresses].values}
          response
        end

      end
    end
  end
end
