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
        def create_address(offering_id, location, vlan_id)
          options = {
            :method   => 'POST',
            :expects  => 200,
            :path     => '/addresses',
          }
          params = {
            'offeringID' => offering_id,
            'location' => location,
            'vlanID' => vlan_id
          }
          options.merge!(Fog::IBM.form_body(params.merge(extra_params)))
          request(options)
        end

      end
    end
  end
end
