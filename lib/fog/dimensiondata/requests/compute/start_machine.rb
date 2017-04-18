module Fog
  module Compute
    class Joyent
      class Real
        def start_machine(id)
          request(
            :method => "POST",
            :path => "/my/machines/#{id}",
            :query => {"action" => "start"},
            :expects => 202
          )
        end
      end
    end
  end
end
