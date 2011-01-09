module Fog
  module TerremarkEcloud
    class Compute

      class Real

        def shutdown_vm(vm_uri)
          response = request({
              :uri     => vm_uri + '/power/action/shutdown',
              :method  => 'POST',
              :expects => 204
            })

          { 'task_uri' => response.headers['Location'] }
        end

      end
    end
  end
end
