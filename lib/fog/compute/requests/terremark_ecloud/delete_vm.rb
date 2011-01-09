module Fog
  module TerremarkEcloud
    class Compute

      class Real

        def delete_vm(uri)
          response = request({
              :uri     => uri,
              :method  => 'DELETE',
              :expects => 202
            })

          # raise here if Location is missing?

          { 'task_uri' => response.headers['Location'] }
        end

      end
    end
  end
end
