module Fog
  module Compute
    class IBM
      class Real
        # Returns the vlan offerings for user
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
        def list_vlans
          request(
            :method   => 'GET',
            :expects  => 200,
            :path     => '/offerings/vlan'
          )
        end
      end
      class Mock
        def list_vlans
          response = Excon::Response.new
          response.status = 200
          response.body = {"vlan"=>
              [{"location"=>"101",
                "id"=>"75321",
                "name"=>"FOG-VLAN1"}]}
          response
        end
      end
    end
  end
end
