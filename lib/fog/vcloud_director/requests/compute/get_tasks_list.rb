module Fog
  module Compute
    class VcloudDirector
      class Real

        def get_tasks_list(tasks_list_id)
          request(
            :expects  => 200,
            :method   => 'GET',
            :parser => Fog::ToHashDocument.new,
            :path     => "tasksList/#{tasks_list_id}"
          )
        end
        

      end
      
    end
  end
end