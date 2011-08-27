module Fog
  module DNS
    class Rackspace
      class Real
        def modify_domain(domain_id, options={})

          path = "domains/#{domain_id}"
          data = {}

          if options.has_key? :ttl
            data['ttl'] = options[:ttl]
          end
          if options.has_key? :comment
            data['comment'] = options[:comment]
          end
          if options.has_key? :email_address
            data['emailAddress'] = options[:email_address]
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
