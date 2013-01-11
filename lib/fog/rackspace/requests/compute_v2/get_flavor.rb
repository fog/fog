module Fog
  module Compute
    class RackspaceV2
      class Real
        def get_flavor(flavor_id)
          request(
            :expects => [200, 203],
            :method => 'GET',
            :path => "flavors/#{flavor_id}"
          )
        end
      end

      class Mock
        def get_flavor(flavor_id)
          flavor = self.data[:flavors][flavor_id]
          if flavor.nil?
            raise Fog::Compute::RackspaceV2::NotFound
          else
            response(:body => {"flavor" => flavor})
          end
        end
      end
    end
  end
end
