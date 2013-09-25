module Fog
  module Compute
    class Ecloud
      class Real
        basic_request :get_layout
      end

      class Mock
        def get_layout(uri)
          environment_id = id_from_uri(uri)
          layout = self.data[:layouts][environment_id]

          response(:body =>  layout)
        end
      end
    end
  end
end
