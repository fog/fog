module Fog
  module DNS
    class Rackspace
      class Real
        def list_domain_details(domain_id, options={})

          validate_path_fragment :domain_id, domain_id

          path = "domains/#{domain_id}"
          query_data = {}

          if options.has_key? :show_records
            query_data['showRecords'] = options[:show_records]
          end
          if options.has_key? :show_subdomains
            query_data['showSubdomains'] = options[:show_subdomains]
          end

          if !query_data.empty?
            path = path + '?' + array_to_query_string(query_data)
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
