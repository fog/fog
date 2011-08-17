module Fog
  module DNS
    class Rackspace
      class Real
        def list_domains(options={})
          request(
            :expects  => 200,
            :method   => 'GET',
            :path     => 'domains'
          )
        end
      end
    end
  end
end
