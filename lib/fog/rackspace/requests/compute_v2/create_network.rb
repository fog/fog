module Fog
  module Compute
    class RackspaceV2
      class Real
        def create_network(label, cidr)
          data = {
            'network' => {
              'label' => label,
              'cidr' => cidr
            }
          }

          request(
            :method => 'POST',
            :body => Fog::JSON.encode(data),
            :path => "os-networksv2",
            :expects => 200
          )
        end
      end
    end
  end
end
