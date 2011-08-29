module Fog
  module DNS
    class Rackspace
      class Real
        def modify_domain(domain_id, options={})

          validate_path_fragment :domain_id, domain_id

          path = "domains/#{domain_id}"
          data = {}

          if options.has_key? :ttl
            data['ttl'] = options[:ttl]
          end
          if options.has_key? :comment
            data['comment'] = options[:comment]
          end
          if options.has_key? :email
            data['emailAddress'] = options[:email]
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
