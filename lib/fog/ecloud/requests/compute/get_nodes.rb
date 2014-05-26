module Fog
  module Compute
    class Ecloud
      class Real
        basic_request :get_nodes
      end

      class Mock
        def get_nodes(uri)
          internet_service_id = id_from_uri(uri)
          internet_service    = self.data[:internet_services][internet_service_id]

          response(:body => internet_service)
        end
      end
    end
  end
end
