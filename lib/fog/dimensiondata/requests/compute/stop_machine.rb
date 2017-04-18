module Fog
  module Compute
    class Joyent
      class Real
        def stop_machine(uuid)
          request(
            :method => "POST",
            :path => "/my/machines/#{uuid}",
            :query => {"action" => "stop"},
            :expects => 202
          )
        end
      end
    end
  end
end
