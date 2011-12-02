module Fog
  module Compute
    class IBM
      class Real

        # Get vlans
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * images<~Array>
        # TODO: docs
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
          response.body = {"addresses"=>
              [{"location"=>"101",
                "mode"=>0,
                "offeringId"=>"20001223",
                "id"=>"75321",
                "type"=>1,
                "ip"=>"170.224.192.210 ",
                "hostname"=>"170.224.192.210 ",
                "state"=>2}]},
          response
        end

      end
    end
  end
end
