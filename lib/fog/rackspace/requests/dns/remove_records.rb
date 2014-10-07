module Fog
  module DNS
    class Rackspace
      class Real
        def remove_records(domain_id, record_ids)
          validate_path_fragment :domain_id, domain_id

          path = "domains/#{domain_id}/records?" + record_ids.map { |record_id| "id=#{record_id}" }.join('&')

          request(
            :expects  => [202, 204],
            :method   => 'DELETE',
            :path     => path
          )
        end
      end
    end
  end
end
