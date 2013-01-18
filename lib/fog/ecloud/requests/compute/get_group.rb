module Fog
  module Compute
    class Ecloud
      class Real
        basic_request :get_group
      end

      class Mock
        def get_group(uri)
          group_id = id_from_uri(uri)
          group = self.data[:groups][group_id]

          response(:body =>  group)
        end
      end
    end
  end
end
