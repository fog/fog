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
          # Loop through addresses and update states and values if they aren't set
          self.data[:addresses].values.each do |address|
            address['state']    = 2 if address['state'] == 0
            address['ip']       = Fog::IBM::Mock.ip_address if address['ip'].empty?
            address['mode']     = 0 unless address.key? 'mode'
            address['hostname'] = Fog::IBM::Mock.hostname unless address.key? 'hostname'
            address['type']     = 1 unless address.key? 'type'
          end
          response        = Excon::Response.new
          response.status = 200
          response.body   = { 'addresses' => self.data[:addresses].values }
          response
        end
      end
    end
  end
end
