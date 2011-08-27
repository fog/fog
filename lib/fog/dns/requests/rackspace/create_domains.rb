module Fog
  module DNS
    class Rackspace
      class Real
        def create_domains(domains)
          data = {
            'domains' => []
          }

          domains.each do |domain|
            data['domains'] << {
              'name' => domain[:name],
              'emailAddress' => domain[:email_address],
              'recordsList' => {
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
            }
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
