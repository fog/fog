module Fog
  module DNS
    class Rackspace
      class Real
        def modify_record(domain_id, record_id, options={})
          validate_path_fragment :domain_id, domain_id
          validate_path_fragment :record_id, record_id

          path = "domains/#{domain_id}/records/#{record_id}"
          data = {}

          if options.key? :ttl
            data['ttl'] = options[:ttl]
          end
          if options.key? :name
            data['name'] = options[:name]
          end
          if options.key? :data
            data['data'] = options[:data]
          end

          if data.empty?
            return
          end

          request(
            :expects  => [202, 204],
            :method   => 'PUT',
            :path     => path,
            :body     => Fog::JSON.encode(data)
          )
        end
      end
    end
  end
end
