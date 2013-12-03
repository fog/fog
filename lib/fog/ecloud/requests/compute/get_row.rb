module Fog
  module Compute
    class Ecloud
      class Real
        basic_request :get_row
      end

      class Mock
        def get_row(uri)
          row_id = id_from_uri(uri)
          row = self.data[:rows][row_id]

          response(:body =>  row)
        end
      end
    end
  end
end
