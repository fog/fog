module Fog
  module DNS
    class Rackspace
      class Real
        def remove_domains(domain_ids, options={})

          path = "domains?" + domain_ids.collect { |domain_id| "id=#{domain_id}" }.join('&')
          query_data = {}

          if options.has_key? :delete_subdomains
            query_data['deleteSubdomains'] = options[:delete_subdomains]
          end

          if !query_data.empty?
            path = path + '&' + array_to_query_string(query_data)
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
