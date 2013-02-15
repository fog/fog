module Fog
  module Compute
    class Ecloud
      class Real
        basic_request :rows_delete, 204, 'DELETE'
      end

      class Mock
        def rows_delete(uri)
          row_id = id_from_uri(uri)
          self.data[:rows].delete(row_id)
          self.data[:layouts].values.each do |layout|
            layout[:Rows][:Row].delete_if { |r| r[:id] == row_id }
          end

          response(:body =>  nil, :status => 204)
        end
      end
    end
  end
end
