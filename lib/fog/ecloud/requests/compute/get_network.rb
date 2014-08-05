module Fog
  module Compute
    class Ecloud
      class Real
        basic_request :get_network
      end

      class Mock
        def get_network(uri)
          network_id = id_from_uri(uri)
          network    = self.data[:networks][network_id].dup

          if network
            response(:body => Fog::Ecloud.slice(network, :id, :environment_id))
          else response(:status => 404) # ?
          end
        end
      end
    end
  end
end
