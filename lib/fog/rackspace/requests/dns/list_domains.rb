module Fog
  module DNS
    class Rackspace
      class Real
        def list_domains(options={})
          path = 'domains'
          unless options.empty?
            path += "?#{array_to_query_string(options)}"
          end

          request(
            :expects  => 200,
            :method   => 'GET',
            :path     => path
          )
        end
      end
    end
  end
end
