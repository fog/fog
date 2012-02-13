module Fog
  module Compute
    class IBM
      class Real

        # Requests a new static IP address to be created
        #
        # ==== Parameters
        # * location_id<~String> - id of location
        # * offering_id<~String> - id for offering
        # * vlan_id<~String> - id of vlan
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'location'<~String>: location of new address
        #     * 'offeringId'<~String>: offering id of new address
        #     * 'id'<~String>: id
        #     * 'ip'<~String>: returns string of spaces (ip not yet allocated right after creation)
        #     * 'state'<~Integer>: status of address (0 when new)
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

        def create_address(location_id, offering_id="20001223", options={})
          address         = Fog::IBM::Mock.create_address(location_id, offering_id, options)
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
