module Fog
  module Compute
    class Ecloud
      class Real
        basic_request :get_layouts
      end

      class Mock
        def get_layouts(uri)
          environment_id = id_from_uri(uri)
          layout = self.data[:layouts][environment_id]

          response(:body =>  layout)
        end
      end
    end
  end
end
