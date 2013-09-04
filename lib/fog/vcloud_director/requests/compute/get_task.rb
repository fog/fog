module Fog
  module Compute
    class VcloudDirector
      class Real

        def get_task(task_id)
          request(
            :expects  => 200,
            :method   => 'GET',
            :parser => Fog::ToHashDocument.new,
            :path     => "task/#{task_id}"
          )
        end
        

      end
      
    end
  end
end