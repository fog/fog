module Fog
  module Compute
    class Ecloud
      class Real
        basic_request :groups_delete, 204, 'DELETE'
      end

      class Mock
        def groups_delete(uri)
          group_id = id_from_uri(uri)
          self.data[:groups].delete(group_id)
          self.data[:rows].values.each do |row|
            row[:Groups][:Group].delete_if { |g| g[:id] == group_id }
          end
          self.data[:layouts].values.each do |layout|
            layout[:Rows][:Row].each do |row|
              row[:Groups][:Group].delete_if { |g| g[:id] == group_id }
            end
          end

          response(:body =>  nil, :status => 204)
        end
      end
    end
  end
end
