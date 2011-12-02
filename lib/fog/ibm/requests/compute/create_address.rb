module Fog
  module Compute
    class IBM
      class Real

        # Create an address
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>
        # TODO: docs
        def create_address(location, offering_id, options={})
          request(
            :method   => 'POST',
            :expects  => 200,
            :path     => '/addresses',
            :body     => {
              'offeringID' => offering_id,
              'location'   => location,
              'vlanID'     => options[:vlan_id]
            }
          )
        end

      end

      class Mock

        def create_address(location_id, offering_id="20001223", vlan_id=nil)
          address         = Fog::IBM::Mock.create_address(location_id, offering_id, vlan_id)
          self.data[:addresses][address['id']] = address
          response        = Excon::Response.new
          response.status = 200
          response.body   = address
          response
        end

      end
    end
  end
end
