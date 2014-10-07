module Fog
  module DNS
    class Rackspace
      class Real
        def add_records(domain_id, records)
          validate_path_fragment :domain_id, domain_id

          data = {
            'records' => records.map do |record|
              record_data = {
                'name' => record[:name],
                'type' => record[:type],
                'data' => record[:data]
              }

              if record.key? :ttl
                record_data['ttl'] = record[:ttl]
              end

              if record.key? :priority
                record_data['priority'] = record[:priority]
              end
              record_data
            end
          }

          request(
            :expects  => 202,
            :method   => 'POST',
            :path     => "domains/#{domain_id}/records",
            :body     => Fog::JSON.encode(data)
          )
        end
      end
    end
  end
end
