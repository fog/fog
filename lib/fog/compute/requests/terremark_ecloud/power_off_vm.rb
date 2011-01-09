module Fog
  module TerremarkEcloud
    class Compute

      class Real

        def power_off_vm(vm_uri)
          response = request({
              :uri     => vm_uri + '/power/action/powerOff',
              :method  => 'POST',
              :expects => 202
            })

          { 'task_uri' => response.headers['Location'] }
        end

      end
    end
  end
end
