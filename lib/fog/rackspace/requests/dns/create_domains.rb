module Fog
  module DNS
    class Rackspace
      class Real
        def create_domains(domains)
          data = {
            'domains' => []
          }

          domains.each do |domain|
            domain_data =
              {
                'name' => domain[:name],
                'emailAddress' => domain[:email]
              }

            if domain.has_key? :records
              domain_data['recordsList'] = {
                'records' => domain[:records].collect do |record|
                  record_data = {
                    'ttl' => record[:ttl],
                    'data' => record[:data],
                    'name' => record[:name],
                    'type' => record[:type],
                  }

                  if record.has_key? :priority
                    record_data.merge!({'priority' => record[:priority]})
                  else
                    record_data
                  end
                end
              }
            end
            data['domains'] << domain_data
          end

          request(
            :expects  => 202,
            :method   => 'POST',
            :path     => 'domains',
            :body     => MultiJson.encode(data)
          )
        end
      end
    end
  end
end
