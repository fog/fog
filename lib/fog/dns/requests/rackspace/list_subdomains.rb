module Fog
  module DNS
    class Rackspace
      class Real
        def list_subdomains(domain_id, options={})

          path = "domains/#{domain_id}/subdomains"
          if !options.empty?
            path = path + '?' + array_to_query_string(options)
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
