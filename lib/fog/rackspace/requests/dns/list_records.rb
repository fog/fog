module Fog
  module DNS
    class Rackspace
      class Real
        def list_records(domain_id, options={})
          validate_path_fragment :domain_id, domain_id

          path = "domains/#{domain_id}/records"
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
