module Fog
  module DNS
    class Rackspace
      class Real
        def list_record_details(domain_id, record_id)

          validate_path_fragment :domain_id, domain_id
          validate_path_fragment :record_id, record_id

          path = "domains/#{domain_id}/records/#{record_id}"

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
