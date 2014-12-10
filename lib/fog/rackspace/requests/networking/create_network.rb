module Fog
  module Rackspace
    class Networking
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

      class Mock
        def create_network(label, cidr)
          network_id = Fog::Rackspace::MockData.uuid

          self.data[:networks][network_id] = {
            'id' => network_id,
            'label' => label,
            'cidr' => cidr
          }
          response(:body => { 'network' => self.data[:networks][network_id] })
        end
      end
    end
  end
end
