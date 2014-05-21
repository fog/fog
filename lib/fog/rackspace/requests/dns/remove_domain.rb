module Fog
  module DNS
    class Rackspace
      class Real
        def remove_domain(domain_id, options={})
          validate_path_fragment :domain_id, domain_id

          path = "domains/#{domain_id}"
          query_data = {}

          if options.key? :delete_subdomains
            query_data['deleteSubdomains'] = options[:delete_subdomains].to_s
          end

          if !query_data.empty?
            path = path + '?' + array_to_query_string(query_data)
          end

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
