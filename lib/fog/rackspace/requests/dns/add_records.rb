module Fog
  module DNS
    class Rackspace
      class Real
        def add_records(domain_id, records)

          validate_path_fragment :domain_id, domain_id

          data = {
            'records' => records.collect do |record|
              record_data = {
                'name' => record[:name],
                'type' => record[:type],
                'data' => record[:data]
              }

              if record.has_key? :priority
                record_data['priority'] = record[:priority]
              end
              record_data
            end
          }

          request(
            :expects  => 202,
            :method   => 'POST',
            :path     => "domains/#{domain_id}/records",
            :body     => MultiJson.encode(data)
          )
        end
      end
    end
  end
end
