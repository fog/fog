module Fog
  module DNS
    class Rackspace
      class Real
        def modify_record(domain_id, record_id, options={})

          validate_path_fragment :domain_id, domain_id
          validate_path_fragment :record_id, record_id

          path = "domains/#{domain_id}/records/#{record_id}"
          data = {}

          if options.has_key? :ttl
            data['ttl'] = options[:ttl]
          end
          if options.has_key? :name
            data['name'] = options[:name]
          end
          if options.has_key? :data
            data['data'] = options[:data]
          end

          if data.empty?
            return
          end

          request(
            :expects  => [202, 204],
            :method   => 'PUT',
            :path     => path,
            :body     => MultiJson.encode(data)
          )
        end
      end
    end
  end
end
