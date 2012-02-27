module Fog
  module Compute
    class Joyent
      class Real
        def create_machine(params = {})
          request(
            :method => "POST",
            :path => "/my/machines",
            :body => params,
            :expects => [200, 201, 202]
          )
        end
      end
    end
  end
end
